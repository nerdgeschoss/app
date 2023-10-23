# frozen_string_literal: true

class CreateBankHolidays < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_holidays, id: :uuid do |t|
      t.integer :year, null: false
      t.date :dates, array: true, null: false, default: []

      t.timestamps
    end

    add_index :bank_holidays, :year, unique: true
  end
end
