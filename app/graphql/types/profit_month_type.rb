# frozen_string_literal: true

module Types
  class ProfitMonthType < Types::BaseObject
    description "Profit data for a single calendar month inside a profit report window."

    field :date, GraphQL::Types::ISO8601Date, null: false,
      description: "Start-of-month date, or the report's lower bound if the month was partially covered."
    field :rows, [Types::ProfitRowType], null: false,
      description: "One row per active user in this month-slice."
    field :revenue_by_project, [Types::ProjectRevenueType], null: false,
      description: "Per-project breakdown aggregated across all users, ordered by revenue descending."
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

    def total_revenue
      object.rows.sum(&:revenue)
    end

    def total_cost
      object.rows.sum(&:cost)
    end

    def total_profit
      object.rows.sum { _1.revenue - _1.cost }
    end
  end
end
