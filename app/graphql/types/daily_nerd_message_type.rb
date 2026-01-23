# frozen_string_literal: true

module Types
  class DailyNerdMessageType < Types::BaseObject
    field :id, ID, null: false
    field :message, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user, Types::UserType, null: false
  end
end
