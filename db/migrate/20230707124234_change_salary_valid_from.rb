# frozen_string_literal: true

class ChangeSalaryValidFrom < ActiveRecord::Migration[7.0]
  def change
    add_column :salaries, :valid_from, :date
    up_only { execute "UPDATE salaries SET valid_from = LOWER(valid_during)" }
    change_column_null :salaries, :valid_from, false
    remove_column :salaries, :valid_during, :daterange
  end
end
