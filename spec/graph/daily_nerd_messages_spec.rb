# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DailyNerdMessages", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:message) { daily_nerd_messages(:johns_message) }

  it "lists daily nerd messages if the viewer is an employee" do
    login(user)
    gql <<~GRAPHQL
      {
        dailyNerdMessages {
          nodes {
            message
            createdAt
            user {
              displayName
            }
          }
        }
      }
    GRAPHQL
    messages = data.daily_nerd_messages.nodes.map(&:message)
    expect(messages).to include(message.message)
  end

  it "filters by user" do
    login(user)
    query = <<~GRAPHQL
      query DailyNerdMessages($userId: ID!) {
        dailyNerdMessages(userId: $userId) {
          nodes {
            message
            user {
              displayName
            }
          }
        }
      }
    GRAPHQL
    gql query, variables: {userId: user.id}
    data.daily_nerd_messages.nodes.each do |node|
      expect(node.user.display_name).to eq user.display_name
    end
  end

  it "filters by date range" do
    login(user)
    query = <<~GRAPHQL
      query DailyNerdMessages($fromDate: ISO8601Date!, $toDate: ISO8601Date!) {
        dailyNerdMessages(fromDate: $fromDate, toDate: $toDate) {
          nodes {
            message
            createdAt
          }
        }
      }
    GRAPHQL
    gql query, variables: {fromDate: "2023-01-25", toDate: "2023-01-26"}
    messages = data.daily_nerd_messages.nodes.map(&:message)
    expect(messages).to eq [daily_nerd_messages(:johns_second_message).message]
  end
end
