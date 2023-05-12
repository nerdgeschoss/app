# frozen_string_literal: true

class AddDailyNerdEntriesToSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :sprint_feedbacks, :daily_nerd_entry_dates, :datetime, array: true, default: [], null: false
  end
end
