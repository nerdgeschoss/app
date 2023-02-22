# frozen_string_literal: true

class CreateSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :sprints, id: :uuid do |t|
      t.string :title, null: false
      t.daterange :sprint_during, null: false
      t.integer :working_days, null: false

      t.timestamps
    end
  end
end
