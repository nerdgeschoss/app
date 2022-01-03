class CreateLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :leaves, id: :uuid do |t|
      t.daterange :leave_during, null: false
      t.string :title, null: false
      t.string :type, null: false, default: "paid"
      t.string :status, null: false, default: "pending_approval"
      t.date :days, null: false, array: true, default: []
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
