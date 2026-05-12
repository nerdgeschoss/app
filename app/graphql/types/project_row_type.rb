# frozen_string_literal: true

module Types
  class ProjectRowType < Types::BaseObject
    description "Per-project profit data for a single month, aggregated across all contributors."

    field :id, ID, null: false,
      description: "Globally unique identifier scoped to the parent report and month."
    field :project, String, null: false,
      description: "Project name."
    field :hours, Float, null: false,
      description: "Total billable hours logged on this project in this month."
    field :revenue, Float, null: false,
      description: "Total revenue for this project this month, in EUR."
    field :cost, Float, null: false,
      description: "Cost allocated to this project (sum of contributors' allocated costs), in EUR."
    field :profit, Float, null: false,
      description: "Revenue minus allocated cost."
    field :running_revenue, Float, null: false,
      description: "Cumulative project revenue across all months processed up to and including this one."
    field :running_cost, Float, null: false,
      description: "Cumulative project cost across all months processed up to and including this one."
    field :running_profit, Float, null: false,
      description: "Cumulative project profit across all months processed up to and including this one."
    field :contributors, [Types::ProjectContributorType], null: false,
      description: "Per-user breakdown of hours, revenue and allocated cost."
  end
end
