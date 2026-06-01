# frozen_string_literal: true

module Types
  class ProfitMonthType < Types::BaseObject
    description "Profit data for a single calendar month inside a profit report window."

    field :id, ID, null: false,
      description: "Globally unique identifier scoped to the parent report."
    field :date, GraphQL::Types::ISO8601Date, null: false,
      description: "Start-of-month date, or the report's lower bound if the month was partially covered."
    field :rows, [Types::ProfitRowType], null: false,
      description: "One row per active user in this month-slice."
    field :project_rows, [Types::ProjectRowType], null: false,
      description: "One row per project active in this month-slice, with cost allocated by hours."
    field :revenue_by_project, [Types::ProjectRevenueType], null: false,
      description: "Per-project revenue/hours summary (without cost). Use project_rows for full profit data."
    field :total_revenue, Float, null: false,
      description: "Sum of revenue across all rows."
    field :total_cost, Float, null: false,
      description: "Sum of cost across all rows."
    field :total_profit, Float, null: false,
      description: "Sum of (revenue - cost) across all rows."
    field :total_running_revenue, Float, null: false,
      description: "Cumulative team revenue across all months up to and including this one."
    field :total_running_cost, Float, null: false,
      description: "Cumulative team cost across all months up to and including this one."
    field :total_running_profit, Float, null: false,
      description: "Cumulative team profit across all months up to and including this one."
    field :total_project_revenue, Float, null: false,
      description: "Sum of revenue across all project rows in this month."
    field :total_project_cost, Float, null: false,
      description: "Sum of cost across all project rows in this month."
    field :total_project_profit, Float, null: false,
      description: "Sum of (revenue - cost) across all project rows in this month."
    field :total_project_running_revenue, Float, null: false,
      description: "Cumulative project-level revenue across months up to and including this one."
    field :total_project_running_cost, Float, null: false,
      description: "Cumulative project-level cost across months up to and including this one."
    field :total_project_running_profit, Float, null: false,
      description: "Cumulative project-level profit across months up to and including this one."

    def total_revenue
      object.rows.sum(&:revenue)
    end

    def total_cost
      object.rows.sum(&:cost)
    end

    def total_profit
      object.rows.sum { it.revenue - it.cost }
    end
  end
end
