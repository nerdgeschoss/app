# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TimeEntries", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:entry) { time_entries(:entry_1) }

  it "hides time entries if no one is logged in" do
    gql <<~GRAPHQL
      {
        timeEntries {
          nodes {
            hours
          }
        }
      }
    GRAPHQL
    expect(data.time_entries.nodes).to be_empty
  end

  it "lists time entries if the viewer is an employee" do
    login(user)
    gql <<~GRAPHQL
      {
        timeEntries {
          nodes {
            hours
            roundedHours
            billable
            notes
          }
        }
      }
    GRAPHQL
    hours = data.time_entries.nodes.map(&:hours)
    expect(hours).to include(entry.hours.to_f)
  end

  it "filters by user" do
    login(user)
    query = <<~GRAPHQL
      query TimeEntries($userId: ID!) {
        timeEntries(userId: $userId) {
          nodes {
            hours
            user {
              displayName
            }
          }
        }
      }
    GRAPHQL
    gql query, variables: {userId: user.id}
    data.time_entries.nodes.each do |node|
      expect(node.user.display_name).to eq user.display_name
    end
  end

  context "restricting fields" do
    it "restricts billable_rate for non-hr employees" do
      login(users(:yuki))
      gql <<~GRAPHQL
        {
          timeEntries {
            nodes {
              billableRate
            }
          }
        }
      GRAPHQL
      expect(gql_errors.first.message).to include "hidden due to permissions"
    end

    it "shows billable_rate for hr employees" do
      login(users(:admin))
      gql <<~GRAPHQL
        {
          timeEntries {
            nodes {
              billableRate
            }
          }
        }
      GRAPHQL
      expect(data.time_entries.nodes.first.billable_rate).to eq entry.billable_rate.to_i
    end
  end
end
