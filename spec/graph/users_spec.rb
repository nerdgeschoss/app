# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:query) do
    <<-GRAPHQL
      {
        viewer {
          email
        }
      }
    GRAPHQL
  end

  it "hides user if no one is logged in" do
    gql <<~GRAPHQL
      {
        users {
          nodes {
            displayName
          }
        }
      }
    GRAPHQL
    expect(data.users.nodes).to be_empty
  end

  it "lists users if the viewer is an employee" do
    login(user)
    gql <<~GRAPHQL
      {
        users {
          nodes {
            displayName
          }
        }
      }
    GRAPHQL
    expect(data.users.nodes.map(&:display_name)).to include(user.display_name)
  end

  context "restricting fields" do
    it "restricts users remaining holidays for non-hr employees" do
      login(users(:yuki))
      gql <<~GRAPHQL
        {
          user(id: "#{user.id}") {
            remainingHolidays
          }
        }
      GRAPHQL
      expect(gql_errors.first.message).to include "hidden due to permissions"
    end

    it "shows it for hr employees" do
      login(users(:admin))
      gql <<~GRAPHQL
        {
          user(id: "#{user.id}") {
            remainingHolidays
          }
        }
      GRAPHQL
      expect(data.user.remaining_holidays).to eq user.remaining_holidays
    end
  end
end
