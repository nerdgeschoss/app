# frozen_string_literal: true

class AddHourGoalToSprintFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_column :sprint_feedbacks, :hour_goal, :decimal
  end
end
