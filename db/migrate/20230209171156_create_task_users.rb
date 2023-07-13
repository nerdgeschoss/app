# frozen_string_literal: true

class CreateTaskUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :task_users, id: :uuid do |t|
      t.references :task, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :task_users, [:task_id, :user_id], unique: true
  end
end
