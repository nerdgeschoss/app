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

  def self.sync_with_github
    user_ids_by_email = User.pluck(:email, :id).to_h
    sprint_ids_by_title = Sprint.pluck(:title, :id).to_h
    github_tasks = GithubApi.instance.project_items
    current_github_ids = pluck(:github_id)
    new_github_ids = github_tasks.map(&:id).compact
    deleted_ids = current_github_ids - new_github_ids

    tasks = github_tasks.map do |gt|
      next if sprint_ids_by_title[gt.sprint_title].nil?

      {
        sprint_id: sprint_ids_by_title[gt.sprint_title],
        title: gt.title,
        status: gt.status.downcase,
        github_id: gt.id,
        repository: gt.repository,
        issue_number: gt.issue_number,
        story_points: gt.points.to_i
      }
    end.compact

    task_users = github_tasks.flat_map do |gt|
      gt.assignees.map do |assignee|
        user_id = user_ids_by_email[assignee]
        {github_id: gt.id, user_id: user_id} unless user_id.nil?
      end.compact
    end

    Task.transaction do
      if deleted_ids.any?
        task_ids_to_delete = Task.where(github_id: deleted_ids).pluck(:id)
        TaskUser.where(task_id: task_ids_to_delete).delete_all
        Task.where(id: task_ids_to_delete).delete_all
      end

      if tasks.any?
        tasks_result = Task.upsert_all(tasks, returning: %w[id github_id], unique_by: [:github_id])
        task_ids_by_github_id = tasks_result.rows.index_by { |r| r[1] }.transform_values { |r| r[0] }

        task_users.each do |tu|
          tu[:task_id] = task_ids_by_github_id[tu[:github_id]]
          tu.delete(:github_id)
        end

        task_users_with_ids = task_users.select { |tu| tu[:task_id] }
        TaskUser.upsert_all(task_users_with_ids, unique_by: [:task_id, :user_id]) if task_users_with_ids.any?
      end

      done_tasks = tasks.select { |t| t[:status] == "done" }
      finished_sprint_storypoints_by_user = []

      done_tasks.each do |dt|
        task_id = task_ids_by_github_id[dt[:github_id]]
        related_task_users = task_users.select { |tu| tu[:task_id] == task_id }

        related_task_users.each do |tu|
          user_id = tu[:user_id]
          sprint_id = dt[:sprint_id]

          finished_sprint_storypoints_by_user << {
            user_id: user_id,
            sprint_id: sprint_id,
            finished_storypoints: dt[:story_points]
          }
        end
      end

      grouped_finished_storypoints_by_user = finished_sprint_storypoints_by_user
        .group_by { |h| [h[:user_id], h[:sprint_id]] }
        .map do |k, v|
          {
            user_id: k[0],
            sprint_id: k[1],
            finished_storypoints: v.sum { |h| h[:finished_storypoints] }
          }
        end

      all_feedbacks = SprintFeedback.all.map { |sf| {sprint_id: sf[:sprint_id], user_id: sf[:user_id], id: sf[:id]} }
      relevant_fields_from_all_feedbacks = all_feedbacks.map { |sf| sf.slice(:sprint_id, :user_id) }
      relevant_fields_from_grouped_feedbacks = grouped_finished_storypoints_by_user.map { |sf| sf.slice(:sprint_id, :user_id) }

      missing_feedbacks = relevant_fields_from_all_feedbacks - relevant_fields_from_grouped_feedbacks

      missing_feedbacks_with_ids = all_feedbacks.select { |feedback| missing_feedbacks.include? feedback.slice(:sprint_id, :user_id) }

      SprintFeedback.where(id: missing_feedbacks_with_ids.map { |sf| sf[:id] }).delete_all if missing_feedbacks_with_ids.any?

      SprintFeedback.upsert_all(grouped_finished_storypoints_by_user, unique_by: [:sprint_id, :user_id], update_only: :finished_storypoints) if grouped_finished_storypoints_by_user.any?
    end
  end
end
