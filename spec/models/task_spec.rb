# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  issue_number :bigint
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
require "rails_helper"

RSpec.describe Task do
  fixtures :all

  describe ".sync_with_github" do
    before do
      allow_any_instance_of(Github).to receive(:sprint_board_items).and_return(sprint_board_items)
    end

    let(:sprint_board_items) do
      [
        Github::SprintBoardItem.new(
          id: "I_kwDOHqBmEs5py4Jr",
          title: "APP-777 - Implement Banner and QR Code",
          assignee_logins: ["john-github"],
          repository: "nerdgeschoss/project",
          issue_number: 157,
          sprint_title: "S2023-02",
          status: "Done",
          points: 3,
          labels: ["backend"]
        ),
        Github::SprintBoardItem.new(
          id: "I_123",
          title: "APP-123 - Another Task",
          assignee_logins: ["john-github"],
          repository: "nerdgeschoss/project",
          issue_number: 166,
          sprint_title: "S2023-02",
          status: "Todo",
          points: 3,
          labels: ["frontend"]
        )
      ]
    end

    it "creates new tasks and task_users" do
      Task.sync_with_github
      task = Task.find_by github_id: sprint_board_items.first.id
      expect(task.sprint).to eq sprints :empty
      expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
      expect(task.status).to eq "Done"
      expect(task.repository).to eq "nerdgeschoss/project"
      expect(task.issue_number).to eq 157
      expect(task.story_points).to eq 3
      expect(task.users).to eq [users(:john)]
      expect(task.labels).to eq ["backend"]
    end

    it "updates existing tasks" do
      task = tasks :done
      task.update! github_id: sprint_board_items.first.id, users: [users(:admin)], story_points: 13
      Task.sync_with_github
      task.reload
      expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
      expect(task.users).to eq [users(:john)]
      expect(task.repository).to eq "nerdgeschoss/project"
      expect(task.issue_number).to eq 157
      expect(task.sprint).to eq sprints :empty
      expect(task.story_points).to eq 3
      expect(task.status).to eq "Done"
    end

    it "deletes tasks that are not in the list" do
      task = tasks :in_progress

      Task.sync_with_github

      expect(Task.exists?(task.id)).to be false
    end

    it "does not delete tasks that are not in the list if they are done" do
      task = tasks :done

      Task.sync_with_github

      expect(Task.exists?(task.id)).to be true
    end

    it "only updates finished_storypoints" do
      sprint_feedback = sprint_feedbacks(:sprint_feedback_john)
      expect(sprint_feedback).to have_attributes finished_storypoints: 8

      Task.sync_with_github

      expect(sprint_feedback.reload).to have_attributes finished_storypoints: 3
    end
  end
end
