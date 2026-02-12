# frozen_string_literal: true

module Types
  class DailyNerdMessageType < Types::BaseObject
    description "A daily standup ('daily nerd') message posted by a team member."

    field :id, ID, null: false, description: "UUID."
    field :message, String, null: false, description: "The standup update text."
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "When the message was posted."
    field :user, Types::UserType, null: false, description: "The team member who posted this message."
  end
end
