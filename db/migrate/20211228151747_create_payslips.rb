# frozen_string_literal: true

class CreatePayslips < ActiveRecord::Migration[7.0]
  def change
    create_table :payslips, id: :uuid do |t|
      t.date :month, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
