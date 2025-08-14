# frozen_string_literal: true

class ChangeBillableToBoolean < ActiveRecord::Migration[8.0]
  def up
    rename_column :time_entries, :billable, :_billable
    add_column :time_entries, :billable, :boolean, null: false, default: false
    execute <<-SQL
      UPDATE time_entries
      SET billable = CASE
        WHEN _billable = 't' THEN true
        ELSE false
      END
    SQL
    remove_column :time_entries, :_billable
  end

  def down
    rename_column :time_entries, :billable, :_billable
    add_column :time_entries, :billable, :string, null: false, default: "f"
    execute <<-SQL
      UPDATE time_entries
      SET billable = CASE
        WHEN _billable = true THEN 't'
        ELSE 'f'
      END
    SQL
    remove_column :time_entries, :_billable
  end
end
