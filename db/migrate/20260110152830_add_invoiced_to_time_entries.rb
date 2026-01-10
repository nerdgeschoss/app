# frozen_string_literal: true

class AddInvoicedToTimeEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :time_entries, :invoiced, :boolean, null: false, default: false
    up_only { execute "UPDATE time_entries SET invoiced = TRUE" }
  end
end
