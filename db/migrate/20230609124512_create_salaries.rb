# frozen_string_literal: true

class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.daterange :valid_during, null: false
      t.decimal :brut, null: false
      t.decimal :net, null: false
      t.string :hgf_hash

      t.timestamps
    end
  end
end
