# frozen_string_literal: true

module Types
  class SprintType < Types::BaseObject
    description "A work sprint. Aggregates time tracking, story points, and standup participation across all team members."

    field :id, ID, null: false, description: "UUID."
    field :title, String, null: false, description: "Human-readable identifier (e.g. 'Sprint 42')."
    field :sprint_from, GraphQL::Types::ISO8601Date,
      description: "First day of the sprint."
    field :sprint_until, GraphQL::Types::ISO8601Date,
      description: "Last day of the sprint."
    field :total_working_days, Integer, null: false,
      description: "Sum of working days across all team members (excludes holidays, sick days, non-working days)."
    field :total_holidays, Integer, null: false,
      description: "Total holiday days taken by all team members during this sprint."
    field :total_sick_days, Integer, null: false,
      description: "Total sick days taken by all team members during this sprint."
    field :daily_nerd_percentage, Float, null: false,
      description: "Average standup participation rate. Ratio from 0.0 to 1.0 (not a percentage despite the name)."
    field :tracked_hours, Float, null: false,
      description: "Total hours tracked by all members, billable and non-billable. Decimal hours."
    field :billable_hours, Float, null: false,
      description: "Total billable hours tracked by all members. Subset of tracked_hours. Decimal hours."
    field :finished_storypoints, Integer, null: false,
      description: "Total story points completed across all members."
    field :average_rating, Float, null: true,
      description: "Mean retrospective rating (1-5 scale). Null if no ratings submitted."
    field :sprint_feedbacks, SprintFeedbackType.connection_type, null: false,
      description: "Per-user performance records. One entry per team member."
    field :tasks, Types::TaskType.connection_type, null: false,
      description: "GitHub tasks assigned to this sprint."
    field :time_entries, Types::TimeEntryType.connection_type, null: false,
      description: "All time entries logged during this sprint."
  end
end
