# frozen_string_literal: true

class DefaultValuesForSprints < ActiveRecord::Migration[8.0]
  def change
    change_column_default :sprints, :working_days, from: nil, to: 0
    change_column_null :sprint_feedbacks, :daily_nerd_count, false, 0
    change_column_default :sprint_feedbacks, :daily_nerd_count, from: nil, to: 0
    change_column_null :sprint_feedbacks, :tracked_hours, false, 0
    change_column_default :sprint_feedbacks, :tracked_hours, from: nil, to: 0
    change_column_null :sprint_feedbacks, :billable_hours, false, 0
    change_column_default :sprint_feedbacks, :billable_hours, from: nil, to: 0
    change_column_null :sprint_feedbacks, :skip_retro, false, 0
  end
end
