# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  sprint_id    :uuid
#  title        :string           not null
#  status       :string
#  github_id    :string
#  repository   :string
#  issue_number :bigint
#  story_points :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :sprint

  has_many :task_users, dependent: :delete_all
  has_many :users, through: :task_users

  class << self
    def sync_with_github
      user_ids_by_handle = User.pluck(:github_handle, :id).to_h
      sprint_ids_by_title = Sprint.pluck(:title, :id).to_h
      github_tasks = Github.new.project_items
      current_github_ids = pluck(:github_id)
      deleted_ids = current_github_ids - github_tasks.map(&:id).compact

      tasks = github_tasks.map do |gt|
        {
          sprint_id: sprint_ids_by_title[gt.sprint_title],
          title: gt.title,
          status: gt.status,
          github_id: gt.id,
          repository: gt.repository,
          issue_number: gt.issue_number,
          story_points: gt.points
        }
      end

      Task.transaction do
        Task.where(github_id: deleted_ids).destroy_all if deleted_ids.any?

        if tasks.any?
          task_ids_by_github_id = Task.upsert_all(tasks, returning: [:github_id, :id], unique_by: [:github_id]).rows.to_h

          unused_task_users = TaskUser.pluck(:id, :user_id, :task_id).map { |e| [[e[1], e[2]], e[0]] }.to_h
          task_users = github_tasks.flat_map do |task|
            task.assignee_logins.map do |login|
              user_id = user_ids_by_handle[login]
              task_id = task_ids_by_github_id[task.id]
              unused_task_users.delete([user_id, task_id])
              {task_id:, user_id:} unless user_id.nil?
            end.compact
          end
          TaskUser.upsert_all(task_users, unique_by: [:task_id, :user_id]) if task_users.any?
          TaskUser.where(id: unused_task_users.values).delete_all if unused_task_users.any?
        end

        sql = <<-SQL
          WITH points_per_sprint AS (
            SELECT
              sprint_feedbacks.id AS sprint_feedback_id,
              SUM(COALESCE(tasks.story_points, 0)) AS points
            FROM
              sprint_feedbacks
              JOIN sprints ON sprint_feedbacks.sprint_id = sprints.id
              LEFT JOIN task_users ON sprint_feedbacks.user_id = task_users.user_id
              LEFT JOIN tasks ON tasks.id = task_users.task_id AND tasks.sprint_id = sprints.id
            GROUP BY
              1
          )
          UPDATE sprint_feedbacks
          SET finished_storypoints = points_per_sprint.points
          FROM points_per_sprint
          WHERE points_per_sprint.sprint_feedback_id = sprint_feedbacks.id
        SQL
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
