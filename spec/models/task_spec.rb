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
require "rails_helper"

RSpec.describe Task do
  fixtures :all

  describe ".sync_with_github" do
    before do
      allow_any_instance_of(Github).to receive(:project_items).and_return(project_items)
    end

    let(:project_items) do
      [
        Github::SprintBoardItem.new(
          id: "I_kwDOHqBmEs5py4Jr",
          title: "APP-777 - Implement Banner and QR Code",
          assignee_logins: ["john-github"],
          repository: "nerdgeschoss/laic",
          issue_number: 157,
          sprint_title: "S2023-02",
          status: "Done",
          points: 3
        )
      ]
    end

    it "creates new tasks and task_users" do
      Task.sync_with_github
      task = Task.find_by github_id: project_items.first.id
      expect(task.sprint).to eq sprints :empty
      expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
      expect(task.status).to eq "Done"
      expect(task.repository).to eq "nerdgeschoss/laic"
      expect(task.issue_number).to eq 157
      expect(task.story_points).to eq 3
      expect(task.users).to eq [users(:john)]
    end

    it "updates existing tasks" do
      task = tasks :done
      task.update! github_id: project_items.first.id, users: [users(:admin)], story_points: 13
      Task.sync_with_github
      task.reload
      expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
      expect(task.users).to eq [users(:john)]
      expect(task.repository).to eq "nerdgeschoss/laic"
      expect(task.issue_number).to eq 157
      expect(task.sprint).to eq sprints :empty
      expect(task.story_points).to eq 3
      expect(task.status).to eq "Done"
    end

    it "deletes tasks that are not in the list" do
      task = tasks :done

      Task.sync_with_github

      expect(Task.exists?(task.id)).to eq false
    end

    it "only updates finished_storypoints" do
      sprint_feedback = sprint_feedbacks(:sprint_feedback_1)
      expect(sprint_feedback).to have_attributes finished_storypoints: 8

      Task.sync_with_github

      expect(sprint_feedback.reload).to have_attributes finished_storypoints: 3
    end
  end
end
