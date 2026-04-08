# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:done_task) { tasks(:done) }
  let(:in_progress_task) { tasks(:in_progress) }

  it "hides tasks if no one is logged in" do
    gql <<~GRAPHQL
      {
        tasks {
          nodes {
            title
          }
        }
      }
    GRAPHQL
    expect(data.tasks.nodes).to be_empty
  end

  it "lists tasks if the viewer is an employee" do
    login(user)
    gql <<~GRAPHQL
      {
        tasks {
          nodes {
            title
            status
            storyPoints
            repository
            issueNumber
          }
        }
      }
    GRAPHQL
    titles = data.tasks.nodes.map(&:title)
    expect(titles).to include(done_task.title, in_progress_task.title)
  end

  it "filters tasks by sprint" do
    login(user)
    sprint = sprints(:empty)
    query = <<~GRAPHQL
      query Tasks($sprintId: ID!) {
        tasks(sprintId: $sprintId) {
          nodes {
            title
          }
        }
      }
    GRAPHQL
    gql query, variables: {sprintId: sprint.id}
    expect(data.tasks.nodes.map(&:title)).to include(done_task.title)
  end

  it "filters tasks by search" do
    login(user)
    query = <<~GRAPHQL
      query Tasks($search: String!) {
        tasks(search: $search) {
          nodes {
            title
          }
        }
      }
    GRAPHQL
    gql query, variables: {search: "feature"}
    titles = data.tasks.nodes.map(&:title)
    expect(titles).to include(done_task.title)
    expect(titles).not_to include(in_progress_task.title)
  end

  it "filters tasks by status" do
    login(user)
    query = <<~GRAPHQL
      query Tasks($status: TaskStatusEnum!) {
        tasks(status: $status) {
          nodes {
            title
          }
        }
      }
    GRAPHQL
    gql query, variables: {status: "DONE"}
    titles = data.tasks.nodes.map(&:title)
    expect(titles).to include(done_task.title)
    expect(titles).not_to include(in_progress_task.title)
  end

  it "includes assigned users" do
    login(user)
    query = <<~GRAPHQL
      query Tasks($search: String!) {
        tasks(search: $search) {
          nodes {
            title
            users {
              nodes {
                displayName
              }
            }
          }
        }
      }
    GRAPHQL
    gql query, variables: {search: "feature"}
    task_node = data.tasks.nodes.first
    expect(task_node.users.nodes.map(&:display_name)).to include(user.display_name)
  end
end
