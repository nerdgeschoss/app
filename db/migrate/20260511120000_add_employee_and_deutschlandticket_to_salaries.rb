# frozen_string_literal: true

class AddEmployeeAndDeutschlandticketToSalaries < ActiveRecord::Migration[8.0]
  def change
    add_column :salaries, :employee, :boolean, default: true, null: false
    add_column :salaries, :deutschlandticket, :boolean, default: false, null: false
  end
end
