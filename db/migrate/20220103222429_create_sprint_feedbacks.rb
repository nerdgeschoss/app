# frozen_string_literal: true

class CreateSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :sprint_feedbacks, id: :uuid do |t|
      t.references :sprint, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :daily_nerd_count
      t.decimal :tracked_hours
      t.decimal :billable_hours

      t.timestamps
      t.index [:sprint_id, :user_id], unique: true
    end
  end
end
