# frozen_string_literal: true

module Types
  class TimeEntryType < Types::BaseObject
    description "A time tracking entry synced from Harvest."

    field :id, ID, null: false, description: "UUID."
    field :billable, Boolean, null: false, description: "Whether this entry counts towards billable hours."
    field :billable_rate, Integer, null: false, required_permission: :financial_details, description: "Hourly billing rate in EUR."
    field :hours, Float, null: false, description: "Actual hours logged. Decimal hours."
    field :invoiced, Boolean, null: false, description: "Whether this entry has been included on an invoice."
    field :rounded_hours, Float, null: false, description: "Hours rounded to the nearest billing increment. Decimal hours."
    field :start_at, GraphQL::Types::ISO8601DateTime, null: true, description: "When the work started. Null for manually entered entries."
    field :costs, Float, null: false, required_permission: :financial_details, description: "Internal cost for this entry in EUR."
    field :end_at, GraphQL::Types::ISO8601DateTime, null: true, description: "When the work ended. Null for manually entered entries."
    field :notes, String, null: true, description: "Description of the work performed. Null if none provided."
    field :task, Types::TaskType, null: true, method: :task_object, description: "Linked GitHub task. Null if not associated with a task."
    field :project, Types::ProjectType, null: true, description: "Project this entry was logged against. Null if unassigned."
    field :user, Types::UserType, null: false, description: "Team member who logged this entry."
    field :sprint, Types::SprintType, null: false, description: "Sprint this entry falls within."
  end
end
