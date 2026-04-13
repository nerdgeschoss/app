# frozen_string_literal: true

class RemoveSprintWorkingDays < ActiveRecord::Migration[8.0]
  def change
    remove_column(:sprints, :working_days, :integer)
  end
end
