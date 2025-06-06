# frozen_string_literal: true

class AddHarvestEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :harvest_email, :string
    add_index :users, :harvest_email, unique: true
  end
end
