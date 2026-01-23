# frozen_string_literal: true

module Types
  class SprintFeedbackType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :billable_hours, Float, null: false
    field :finished_storypoints, Integer, null: false
    field :retro_rating, Integer, null: true
    field :retro_text, String, null: true
    field :tracked_hours, Float, null: false
    field :daily_nerd_percentage, Float, null: false
    field :billable_per_day, Float, null: false
    field :tracked_per_day, Float, null: false
    field :working_day_count, Integer, null: false
    field :holiday_count, Integer, null: false
    field :sick_day_count, Integer, null: false
    field :non_working_day_count, Integer, null: false
    field :leaves, LeaveType.connection_type, null: false
  end
end
