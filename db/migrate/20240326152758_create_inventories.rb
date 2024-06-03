# frozen_string_literal: true

class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :received_at, null: false
      t.datetime :returned_at
      t.string :name, null: false
      t.string :details

      t.timestamps
    end
  end
end
