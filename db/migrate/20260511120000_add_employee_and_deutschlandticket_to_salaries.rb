# frozen_string_literal: true

class AddEmployeeAndDeutschlandticketToSalaries < ActiveRecord::Migration[8.0]
  def change
    add_column :salaries, :employee, :boolean, default: true, null: false
    add_column :salaries, :deutschlandticket, :decimal, default: 0, null: false
  end
end
