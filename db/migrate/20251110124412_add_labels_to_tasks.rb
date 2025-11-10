# frozen_string_literal: true

class AddLabelsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :labels, :string, array: true, null: false, default: []
  end
end
