# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :sprint, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.string :status
      t.string :github_id, index: {unique: true}
      t.string :repository
      t.bigint :issue_number
      t.integer :story_points

      t.timestamps
    end
  end
end
