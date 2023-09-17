# frozen_string_literal: true

class AddMoneyStatToSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    change_table :sprint_feedbacks, bulk: true do |t|
      t.decimal :turnover
      t.decimal :costs
    end
  end
end
