class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :sprint, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.string :status, null: false
      t.integer :story_points

      t.timestamps
    end
  end
end
