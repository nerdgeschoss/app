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
require "rails_helper"

RSpec.describe Task do
  fixtures :all

  describe ".sync_with_github" do
    before do
      github_api = GithubApi.instance
      allow(github_api).to receive(:project_items).and_return(project_items)
    end

    let(:project_items) do
      [
        GithubApi::ProjectItem.new(
          id: "I_kwDOHqBmEs5py4Jr",
          title: "APP-777 - Implement Banner and QR Code",
          assignees: [users(:john).email],
          repository: "nerdgeschoss/laic",
          issue_number: 157,
          sprint_title: sprints(:empty).title,
          status: "done",
          points: 3
        )
      ]
    end

    context "when there are new tasks" do
      it "creates new tasks and task_users" do
        Task.sync_with_github
        task = Task.find_by github_id: project_items.first.id
        expect(task.sprint).to eq sprints :empty
        expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
        expect(task.status).to eq "done"
        expect(task.repository).to eq "nerdgeschoss/laic"
        expect(task.issue_number).to eq 157
        expect(task.story_points).to eq 3
        expect(task.users).to match_array [users(:john)]
      end
    end

    context "when there are existing tasks with the same github_id" do
      it "updates existing task" do
        task = tasks :done
        task.update! github_id: project_items.first.id, users: [], story_points: 13
        task_id = task.id
        Task.sync_with_github
        task.reload
        expect(task.id).to eq task_id
        expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
        expect(task.users).to match_array [users(:john)]
        expect(task.repository).to eq "nerdgeschoss/laic"
        expect(task.issue_number).to eq 157
        expect(task.sprint).to eq sprints :empty
        expect(task.story_points).to eq 3
        expect(task.status).to eq "done"
      end
    end

    context "when there are existing tasks not in the list" do
      it "deletes tasks that are not in the list" do
        task = tasks :done

        Task.sync_with_github

        expect(Task.exists?(task.id)).to eq false
      end
    end

    context "when there are existing task_users not in the list" do
      it "deletes the existing SprintFeedback for the missing user" do
        sprint_feedback_to_delete = sprint_feedbacks :sprint_feedback_2

        Task.sync_with_github

        expect(SprintFeedback.exists?(sprint_feedback_to_delete.id)).to eq false
      end

      it "deletes the existing TaskUser for the missing user" do
        task_user_to_be_deleted = task_users :task_user_2

        Task.sync_with_github

        expect(TaskUser.exists?(task_user_to_be_deleted.id)).to eq false
      end

      it "only updates finished_storypoints" do
        sprint_feedback = sprint_feedbacks(:sprint_feedback_1)

        original_attributes = sprint_feedback.attributes.except("finished_storypoints", "updated_at")

        Task.sync_with_github

        sprint_feedback.reload

        new_attributes = sprint_feedback.attributes.except("finished_storypoints", "updated_at")

        expect(new_attributes).to eq original_attributes
        expect(sprint_feedback.finished_storypoints).to eq 3
      end
    end
  end
end
