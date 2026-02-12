# frozen_string_literal: true

module Types
  class SprintFeedbackType < Types::BaseObject
    description "One team member's performance data and retro feedback for a single sprint."

    field :id, ID, null: false, description: "UUID."
    field :user, Types::UserType, null: false, description: "The team member."
    field :sprint, Types::SprintType, null: false, description: "The sprint this feedback belongs to."
    field :billable_hours, Float, null: false, description: "Billable hours tracked during this sprint. Decimal hours."
    field :finished_storypoints, Integer, null: false, description: "Story points completed by this user in this sprint."
    field :retro_rating, Integer, null: true,
      description: "Retrospective happiness rating, 1 (worst) to 5 (best). Null if not submitted."
    field :retro_text, String, null: true,
      description: "Free-text retrospective feedback. Null if not submitted."
    field :tracked_hours, Float, null: false,
      description: "Total hours tracked, billable + non-billable. Decimal hours."
    field :daily_nerd_percentage, Float, null: false,
      description: "Fraction of working days with a standup posted. Ratio from 0.0 to 1.0."
    field :billable_per_day, Float, null: false,
      description: "Average billable hours per working day. Decimal hours."
    field :tracked_per_day, Float, null: false,
      description: "Average total tracked hours per working day. Decimal hours."
    field :working_day_count, Integer, null: false,
      description: "Net working days for this user (sprint days minus their leaves)."
    field :holiday_count, Integer, null: false, description: "Holiday days taken during the sprint."
    field :sick_day_count, Integer, null: false, description: "Sick days taken during the sprint."
    field :non_working_day_count, Integer, null: false,
      description: "Non-working days (e.g. conference, training) during the sprint."
    field :leaves, LeaveType.connection_type, null: false,
      description: "Leave requests overlapping this sprint."
    field :daily_nerd_messages, Types::DailyNerdMessageType.connection_type, null: false,
      description: "Daily standup messages posted during this sprint."
  end
end
