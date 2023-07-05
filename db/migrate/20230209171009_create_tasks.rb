# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE task_status AS ENUM ('todo', 'in_progress', 'review', 'shaping', 'done', 'idea');
    SQL

    create_table :tasks, id: :uuid do |t|
      t.references :sprint, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.column :status, :task_status, default: "idea", null: false
      t.string :github_id, index: {unique: true}
      t.string :repository
      t.bigint :issue_number
      t.integer :story_points

      t.timestamps
    end
  end

  def down
    drop_table :tasks

    execute <<-SQL
      DROP TYPE task_status;
    SQL
  end
end
