# frozen_string_literal: true

class AddDatesToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.date :born_on
      t.date :hired_on
    end
  end
end
