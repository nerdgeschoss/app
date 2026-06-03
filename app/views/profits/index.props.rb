# frozen_string_literal: true

render "components/current_user"

field :year, Integer, value: -> { @year }
field :years, Integer, array: true, value: -> { @years }
field :months, array: true, value: -> { @months } do
  field :date, Date
  field :total_cost, Float, value: -> { rows.sum(&:cost) }
  field :total_revenue, Float, value: -> { rows.sum(&:revenue) }
  field :total_profit, Float, value: -> { rows.sum { it.revenue - it.cost } }
  field :total_salary, Float, value: -> { rows.sum(&:salary) }
  field :total_payroll_taxes, Float, value: -> { rows.sum(&:payroll_taxes) }
  field :total_benefits, Float, value: -> { rows.sum(&:benefits) }
  field :total_fixed_share, Float, value: -> { rows.sum(&:fixed_share) }
  field :total_sick_refund, Float, value: -> { rows.sum(&:sick_refund) }
  field :total_running_revenue, Float
  field :total_running_cost, Float
  field :total_running_profit, Float
  field :total_project_cost, Float
  field :total_project_revenue, Float
  field :total_project_profit, Float
  field :total_project_running_revenue, Float
  field :total_project_running_cost, Float
  field :total_project_running_profit, Float
  field :revenue_by_project, array: true do
    field :project
    field :hours, Float
    field :revenue, Float
  end
  field :project_rows, array: true do
    field :id
    field :project
    field :hours, Float
    field :revenue, Float
    field :cost, Float
    field :profit, Float
    field :running_revenue, Float
    field :running_cost, Float
    field :running_profit, Float
    field :contributors, array: true do
      field :id
      field :hours, Float
      field :revenue, Float
      field :cost, Float
      field :user do
        field :id
        field :display_name
      end
    end
  end
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
    field :sick_refund, Float
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
