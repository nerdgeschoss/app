# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  issue_number :bigint
#  labels       :string           default([]), not null, is an Array
#  repository   :string
#  status       :citext
#  story_points :integer
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  github_id    :string
#  project_id   :uuid
#  sprint_id    :uuid
#
class Task < ApplicationRecord
  belongs_to :sprint

  has_many :task_users, dependent: :delete_all
  has_many :users, through: :task_users
  has_many :time_entries, dependent: :nullify

  belongs_to :project, optional: true

  class << self
    def sync_with_github
      user_ids_by_handle = User.pluck(:github_handle, :id).to_h
      project_ids_by_repository = Project.pluck(:repository, :id).to_h
      sprint_ids_by_title = Sprint.pluck(:title, :id).to_h
      github_tasks = Github.new.sprint_board_items
      current_github_ids = pluck(:github_id)
      deleted_ids = current_github_ids - github_tasks.filter_map(&:id)

      tasks = github_tasks.map do |gt|
        {
          sprint_id: sprint_ids_by_title[gt.sprint_title],
          title: gt.title,
          status: gt.status,
          github_id: gt.id,
          repository: gt.repository,
          issue_number: gt.issue_number,
          story_points: gt.points,
          project_id: project_ids_by_repository[gt.repository],
          labels: gt.labels
        }
      end

      Task.transaction do
        Task.where(github_id: deleted_ids).where.not(status: "done").destroy_all if deleted_ids.any?

        if tasks.any?
          task_ids_by_github_id = Task.upsert_all(tasks, returning: [:github_id, :id], unique_by: [:github_id]).rows.to_h

          unused_task_users = TaskUser.pluck(:id, :user_id, :task_id).map { |e| [[e[1], e[2]], e[0]] }.to_h
          task_users = github_tasks.flat_map do |task|
            task.assignee_logins.filter_map do |login|
              user_id = user_ids_by_handle[login]
              task_id = task_ids_by_github_id[task.id]
              unused_task_users.delete([user_id, task_id])
              {task_id:, user_id:} unless user_id.nil?
            end
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
              LEFT JOIN tasks ON tasks.id = task_users.task_id AND tasks.sprint_id = sprints.id AND tasks.status = 'Done'
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

  def total_hours
    time_entries.sum(&:hours)
  end

  def total_costs
    time_entries.sum(&:costs)
  end

  def github_url
    return nil unless repository.present? && issue_number.present?

    "https://github.com/#{repository}/issues/#{issue_number}"
  end
end
