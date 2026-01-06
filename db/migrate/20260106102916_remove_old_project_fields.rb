# frozen_string_literal: true

class RemoveOldProjectFields < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :repositories, :string, array: true, default: []
    remove_column :projects, :harvest_ids, :bigint, array: true, default: []
  end
end
