# frozen_string_literal: true

class AddSprintRatingToSprintFeedback < ActiveRecord::Migration[7.0]
  def change
    change_table :sprint_feedbacks, bulk: true do |t|
      t.integer :retro_rating
      t.string :retro_text
    end
  end
end
