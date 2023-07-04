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
require "rails_helper"

RSpec.describe Task do
  fixtures :all
  let(:github_api) { instance_double(GithubApi) }

  before do
    allow(GithubApi).to receive(:instance).and_return(github_api)
  end

  describe ".sync_with_github" do
    let(:github_project_items) do
      [
        GithubApi::ProjectItem.new(
          id: "I_kwDOHqBmEs5py4Jr",
          title: "APP-777 - Implement Banner and QR Code",
          assignees: ["john@example.com"],
          repository: "nerdgeschoss/laic",
          issue_number: 157,
          sprint_title: sprints(:empty).title,
          status: "Done",
          points: 3
        )
      ]
    end

    before do
      allow(github_api).to receive(:project_items).and_return(github_project_items)
    end

    context "when there are new tasks" do
      it "creates new tasks and task_users" do
        Task.sync_with_github
        task = Task.find_by github_id: github_project_items.first.id
        expect(task.sprint).to eq sprints :empty
        expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
        expect(task.status).to eq "Done"
        expect(task.repository).to eq "nerdgeschoss/laic"
        expect(task.issue_number).to eq 157
        expect(task.story_points).to eq 3
        expect(task.users).to match_array [users(:john)]
      end
    end

    context "when there are existing tasks with the same github_id" do
      it "updates existing task" do
        task = tasks :task_1
        task.update! github_id: github_project_items.first.id, users: [], story_points: 13
        Task.sync_with_github
        task.reload
        expect(task.title).to eq "APP-777 - Implement Banner and QR Code"
        expect(task.users).to match_array [users(:john)]
        expect(task.repository).to eq "nerdgeschoss/laic"
        expect(task.issue_number).to eq 157
        expect(task.sprint).to eq sprints(:empty)
        expect(task.story_points).to eq 3
        expect(task.status).to eq "Done"
      end
    end

    context "when there are existing tasks not in the list" do
      it "deletes tasks that are not in the list" do
        task = tasks :task_1
        expect { Task.sync_with_github }.to change { Task.count }.by(-1)
        expect(Task.pluck(:github_id)).not_to include(task.github_id)
      end
    end
  end
end
