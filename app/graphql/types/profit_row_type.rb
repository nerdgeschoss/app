# frozen_string_literal: true

module Types
  class ProfitRowType < Types::BaseObject
    description "Per-user profit data for a single calendar month."

    field :id, ID, null: false,
      description: "Globally unique identifier scoped to the parent report and month."
    field :revenue, Float, null: false,
      description: "Billable revenue for the user in this month, in EUR."
    field :cost, Float, null: false,
      description: "Total monthly cost for the user (salary + payroll taxes + benefits + overhead share), in EUR."
    field :profit, Float, null: false,
      description: "Revenue minus cost for this row, in EUR."
    field :running_revenue, Float, null: false,
      description: "Cumulative revenue for this user across all months processed up to and including this one."
    field :running_cost, Float, null: false,
      description: "Cumulative cost for this user across all months processed up to and including this one."
    field :running_profit, Float, null: false,
      description: "Cumulative profit for this user across all months processed up to and including this one."
    field :salary, Float, null: false,
      description: "Prorated brut salary component of the cost."
    field :payroll_taxes, Float, null: false,
      description: "Prorated employer payroll-tax surcharge. Zero for contractors."
    field :benefits, Float, null: false,
      description: "Prorated benefit cost (e.g. Deutschlandticket)."
    field :fixed_share, Float, null: false,
      description: "Prorated share of the monthly fixed overhead allocated to this user."
    field :sick_refund, Float, null: false,
      description: "Statutory health-insurance refund for sick working days (subtracted from cost)."
    field :revenue_by_project, [Types::ProjectRevenueType], null: false,
      description: "Per-project breakdown of the user's revenue, ordered by revenue descending."
    field :user, Types::UserType, null: false,
      description: "The user this row belongs to."

    def profit
      object.revenue - object.cost
    end
  end
end
