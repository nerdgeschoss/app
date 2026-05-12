# frozen_string_literal: true

render "components/current_user"

field :year, Integer, value: -> { @year }
field :years, Integer, array: true, value: -> { @years }
field :months, array: true, value: -> { @months } do
  field :date, Date
  field :total_cost, Float, value: -> { rows.sum(&:cost) }
  field :total_revenue, Float, value: -> { rows.sum(&:revenue) }
  field :total_profit, Float, value: -> { rows.sum { _1.revenue - _1.cost } }
  field :total_running_revenue, Float
  field :total_running_cost, Float
  field :total_running_profit, Float
  field :rows, array: true do
    field :revenue, Float
    field :cost, Float
    field :profit, Float, value: -> { revenue - cost }
    field :running_revenue, Float
    field :running_cost, Float
    field :running_profit, Float
    field :salary, Float
    field :payroll_taxes, Float
    field :benefits, Float
    field :fixed_share, Float
    field :revenue_by_project, array: true do
      field :project
      field :hours, Float
      field :revenue, Float
    end
    field :user do
      field :id
      field :display_name
    end
  end
end
