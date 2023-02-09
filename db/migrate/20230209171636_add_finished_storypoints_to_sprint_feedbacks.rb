class AddFinishedStorypointsToSprintFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :sprint_feedbacks, :finished_storypoints, :integer, null: false, default: 0
  end
end
