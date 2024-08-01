# frozen_string_literal: true

class AddRetroColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :sprint_feedbacks, bulk: true do |t|
      t.integer :retro_rating
      t.string :retro_text
      t.boolean :skip_retro, default: false
    end
  end
end
