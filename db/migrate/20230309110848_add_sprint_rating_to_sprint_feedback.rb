# frozen_string_literal: true

class AddSprintRatingToSprintFeedback < ActiveRecord::Migration[7.0]
  def change
    add_column :sprint_feedbacks, :retro_rating, :integer
    add_column :sprint_feedbacks, :retro_text, :string
  end
end
