# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :display_name, String, null: false
    field :full_name, String, null: false
    field :email, String, null: false
    field :teams, [String], null: false, method: :team_member_of
    field :ssh_key, String
    field :github_handle, String
    field :hired_on, GraphQL::Types::ISO8601Date
    field :slack_id, String
    field :remaining_holidays, Integer, null: false, required_permission: :financial_details
    field :salaries, SalaryType.connection_type, null: false, required_permission: :financial_details
  end
end
