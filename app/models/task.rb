# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  sprint_id    :uuid             not null
#  title        :string           not null
#  status       :string           not null
#  github_id    :string           not null
#  repository   :string           not null
#  issue_number :bigint
#  story_points :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :sprint

  has_many :task_users, dependent: :delete_all
  has_many :users, through: :task_users

  def self.sync_with_github
    user_ids_by_email = User.pluck(:email, :id).to_h
    sprint_ids_by_title = Sprint.pluck(:title, :id).to_h
    github_tasks = GithubApi.instance.project_items
    current_github_ids = pluck(:github_id)
    new_github_ids = github_tasks.map(&:id)
    deleted_ids = current_github_ids - new_github_ids

    tasks = github_tasks.map do |e|
      next if e.id.nil? || sprint_ids_by_title[e.sprint_title].nil?

      {
        sprint_id: sprint_ids_by_title[e.sprint_title],
        title: e.title,
        status: e.status,
        github_id: e.id,
        repository: e.repository,
        issue_number: e.issue_number,
        story_points: e.points
      }
    end.compact

    task_users = github_tasks.flat_map do |e|
      e.assignees.map do |assignee|
        user_id = user_ids_by_email[assignee]
        {github_id: e.id, user_id: user_id} unless user_id.nil?
      end.compact
    end

    Task.transaction do
      if deleted_ids.any?
        TaskUser.where(task_id: Task.where(github_id: deleted_ids).select(:id)).delete_all
        Task.where(github_id: deleted_ids).delete_all
      end

      if tasks.any?
        tasks_result = Task.upsert_all(tasks, returning: %w[id github_id], unique_by: :github_id)
        task_ids_by_github_id = tasks_result.rows.index_by { |r| r[1] }.transform_values { |r| r[0] }

        task_users.each do |data|
          data[:task_id] = task_ids_by_github_id[data.delete(:github_id)]
        end

        TaskUser.upsert_all(task_users, unique_by: [:task_id, :user_id])
      end
      return "Sync completed successfully"
    end
  end
end
