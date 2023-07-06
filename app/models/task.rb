# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  sprint_id    :uuid             not null
#  title        :string           not null
#  status       :enum             default("idea"), not null
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
      user_ids_by_email = User.pluck(:email, :id).to_h
      sprint_ids_by_title = Sprint.pluck(:title, :id).to_h
      github_tasks = Github.new.project_items
      current_github_ids = pluck(:github_id)
      new_github_ids = github_tasks.map(&:id).compact
      deleted_ids = current_github_ids - new_github_ids

      tasks = github_tasks.map do |gt|
        next if sprint_ids_by_title[gt.sprint_title].nil?

        {
          sprint_id: sprint_ids_by_title[gt.sprint_title],
          title: gt.title,
          status: gt.status.parameterize.underscore,
          github_id: gt.id,
          repository: gt.repository,
          issue_number: gt.issue_number,
          story_points: gt.points.to_i
        }
      end.compact

      task_users = github_tasks.flat_map do |gt|
        gt.assignee_emails.map do |ae|
          user_id = user_ids_by_email[ae]
          {github_id: gt.id, user_id: user_id} unless user_id.nil?
        end.compact
      end

      Task.transaction do
        return unless deleted_ids.any?
        tasks_to_delete = Task.where(github_id: deleted_ids)
        TaskUser.where(task_id: tasks_to_delete.pluck(:id)).destroy_all
        tasks_to_delete.destroy_all

        return unless tasks.any?
        tasks_result = Task.upsert_all(tasks, returning: %w[id github_id], unique_by: [:github_id])
        task_ids_by_github_id = tasks_result.rows.to_h { |r| [r[1], r[0]] }

        task_users = github_tasks.flat_map do |gt|
          gt.assignee_emails.map do |ae|
            user_id = user_ids_by_email[ae]
            task_id = task_ids_by_github_id[gt.id]
            {task_id: task_id, user_id: user_id} unless user_id.nil? || task_id.nil?
          end.compact
        end

        task_users_with_ids = task_users.select { |tu| tu[:task_id] }
        TaskUser.upsert_all(task_users_with_ids, unique_by: [:task_id, :user_id]) if task_users_with_ids.any?

        sql = <<-SQL
          WITH points_per_sprint AS (
            SELECT sprint_feedbacks.id AS sprint_feedback_id, SUM(tasks.story_points) AS points
            FROM tasks
            JOIN task_users ON tasks.id = task_users.task_id
            JOIN sprints ON tasks.sprint_id = sprints.id
            JOIN sprint_feedbacks ON sprint_feedbacks.sprint_id = sprints.id AND task_users.user_id = sprint_feedbacks.user_id
            GROUP BY 1
          )
          UPDATE sprint_feedbacks
          SET finished_storypoints = points_per_sprint.points
          FROM points_per_sprint
          WHERE points_per_sprint.sprint_feedback_id = sprint_feedbacks.id
        SQL
        ActiveRecord::Base.connection.execute(sql)

        sql_delete = <<-SQL
          DELETE FROM sprint_feedbacks
          WHERE NOT EXISTS (
            SELECT 1
            FROM task_users
            JOIN tasks ON tasks.id = task_users.task_id
            WHERE sprint_feedbacks.sprint_id = tasks.sprint_id AND sprint_feedbacks.user_id = task_users.user_id
            AND tasks.github_id NOT IN (?)
          )
        SQL
        ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [sql_delete, deleted_ids]))
      end
    end
  end
end
