# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sprints", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:sprint) { sprints(:empty) }

  it "hides sprints if no one is logged in" do
    gql <<~GRAPHQL
      {
        sprints {
          nodes {
            title
          }
        }
      }
    GRAPHQL
    expect(data.sprints.nodes).to be_empty
  end

  it "lists sprints if the viewer is an employee" do
    login(user)
    gql <<~GRAPHQL
      {
        sprints {
          nodes {
            title
            sprintFrom
            sprintUntil
            totalWorkingDays
            trackedHours
            billableHours
            finishedStorypoints
          }
        }
      }
    GRAPHQL
    titles = data.sprints.nodes.map(&:title)
    expect(titles).to include(sprint.title)
  end

  it "finds a sprint by id" do
    login(user)
    query = <<~GRAPHQL
      query Sprint($id: ID!) {
        sprint(id: $id) {
          title
          sprintFeedbacks {
            nodes {
              user {
                displayName
              }
              trackedHours
            }
          }
        }
      }
    GRAPHQL
    gql query, variables: {id: sprint.id}
    expect(data.sprint.title).to eq sprint.title
  end
end
