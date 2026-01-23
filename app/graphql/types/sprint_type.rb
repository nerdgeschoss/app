# frozen_string_literal: true

module Types
  class SprintType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :sprint_from, GraphQL::Types::ISO8601Date
    field :sprint_until, GraphQL::Types::ISO8601Date
    field :total_working_days, Integer, null: false
    field :total_holidays, Integer, null: false
    field :total_sick_days, Integer, null: false
    field :daily_nerd_percentage, Float, null: false
    field :tracked_hours, Float, null: false
    field :billable_hours, Float, null: false
    field :finished_storypoints, Integer, null: false
    field :average_rating, Float, null: true
    field :sprint_feedbacks, SprintFeedbackType.connection_type, null: false
    field :tasks, Types::TaskType.connection_type, null: false
  end
end
