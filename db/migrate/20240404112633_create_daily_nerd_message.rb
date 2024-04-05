class CreateDailyNerdMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_nerd_messages, id: :uuid do |t|
      t.references :sprint_feedback, null: false, foreign_key: true, type: :uuid
      t.string :message, null: false

      t.timestamps
    end
  end
end
