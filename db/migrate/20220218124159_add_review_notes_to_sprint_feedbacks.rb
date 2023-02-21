# frozen_string_literal: true

class AddReviewNotesToSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :sprint_feedbacks, :review_notes, :string
  end
end
