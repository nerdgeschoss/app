class CreateTimeEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.string :external_id
      t.decimal :hours, null: false
      t.decimal :rounded_hours, null: false
      t.string :billable, null: false
      t.string :project_name, null: false
      t.string :client_name, null: false
      t.string :task, null: false
      t.decimal :billable_rate
      t.decimal :cost_rate
      t.string :notes
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :sprint, null: false, foreign_key: true, type: :uuid

      t.timestamps
      t.index :external_id, unique: true
    end
  end
end
