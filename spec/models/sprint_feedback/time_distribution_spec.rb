# frozen_string_literal: true

require "rails_helper"

RSpec.describe SprintFeedback::TimeDistribution do
  let(:feedback) { sprint_feedbacks.sprint_feedback_john }
  let(:sprint) { feedback.sprint }
  let(:user) { feedback.user }
  let(:distribution) { described_class.new(feedback) }

  before do
    # Replace fixture entries with a controlled set for this user/sprint.
    TimeEntry.where(sprint:, user:).delete_all

    create_entry(client: "Some Client", project: "Some Project", hours: 3.0, task: tasks.done)
    create_entry(client: "Some Client", project: "Some Project", hours: 1.2)
    create_entry(client: "nerdgeschoss", project: "Internal Tool", hours: 0.8, task_string: "personal goals", billable: false)
  end

  it "sums the total tracked hours for the user" do
    expect(distribution.total_hours).to be_within(0.001).of(5.0)
  end

  it "groups by client, ordered by hours descending, with the share of total hours" do
    clients = distribution.clients

    expect(clients.map(&:name)).to eq ["Some Client", "nerdgeschoss"]
    expect(clients.first.hours).to be_within(0.001).of(4.2)
    expect(clients.first.percentage).to be_within(0.001).of(0.84)
    expect(clients.last.percentage).to be_within(0.001).of(0.16)
    expect(clients.sum(&:percentage)).to be_within(0.001).of(1.0)
  end

  it "nests projects under each client" do
    some_client = distribution.clients.find { it.name == "Some Client" }

    expect(some_client.projects.map(&:name)).to eq ["Some Project"]
  end

  it "exposes a linked task on leaf entries, ordered by hours descending" do
    project = distribution.clients.find { it.name == "Some Client" }.projects.first
    entries = project.entries

    expect(entries.map(&:hours).map(&:to_f)).to eq [3.0, 1.2]

    tasked = entries.first
    expect(tasked.task.title).to eq "Implement feature X"
    expect(tasked.task.issue_number).to eq 1
    expect(tasked.percentage).to be_within(0.001).of(0.6)
  end

  it "leaves the task nil for entries without a linked task" do
    project = distribution.clients.find { it.name == "Some Client" }.projects.first
    untasked = project.entries.last

    expect(untasked.task).to be_nil
    expect(untasked.percentage).to be_within(0.001).of(0.24)
  end

  it "treats non-billable internal work as an ordinary client group" do
    internal = distribution.clients.find { it.name == "nerdgeschoss" }
    entry = internal.projects.first.entries.first

    expect(internal.projects.map(&:name)).to eq ["Internal Tool"]
    expect(entry.task).to be_nil
    expect(entry.hours).to be_within(0.001).of(0.8)
  end

  def create_entry(client:, project:, hours:, task: nil, task_string: "Programming", billable: true)
    TimeEntry.create!(
      user:,
      sprint:,
      hours:,
      rounded_hours: hours,
      client_name: client,
      project_name: project,
      task: task_string,
      task_id: task&.id,
      billable:,
      created_at: sprint.sprint_from
    )
  end
end
