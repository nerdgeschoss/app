# frozen_string_literal: true

module Types
  class LeaveType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :days, [GraphQL::Types::ISO8601Date], null: false
    field :status, String, null: false
    field :type, String, null: false
  end
end
