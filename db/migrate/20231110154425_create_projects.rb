class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name
      t.string :client_name
      t.string :repositories, array: true, default: []
      t.bigint :harvest_ids, array: true, default: []

      t.timestamps
    end

    create_table :invoices, id: :uuid do |t|
      t.references :project, type: :uuid, foreign_key: true, null: false
      t.bigint :harvest_id, null: false, index: {unique: true}
      t.string :reference, null: false
      t.decimal :amount, null: false
      t.string :state, null: false
      t.datetime :sent_at
      t.datetime :paid_at

      t.timestamps
    end

    change_table :time_entries do |t|
      t.references :project, type: :uuid, foreign_key: true
      t.references :task, type: :uuid, foreign_key: true
      t.references :invoice, type: :uuid, foreign_key: true
    end

    change_table :tasks do |t|
      t.references :project, type: :uuid, foreign_key: true
    end
  end
end
