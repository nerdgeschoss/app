# frozen_string_literal: true

class AddTimestampsToTimeEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :time_entries, :start_at, :datetime
  end
end
