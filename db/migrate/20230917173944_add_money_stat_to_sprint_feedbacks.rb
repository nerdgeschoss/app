class AddMoneyStatToSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :sprint_feedbacks, :turnover, :decimal
    add_column :sprint_feedbacks, :costs, :decimal
  end
end
