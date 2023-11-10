# frozen_string_literal: true

# == Schema Information
#
# Table name: sprint_feedbacks
#
#  id                     :uuid             not null, primary key
#  sprint_id              :uuid             not null
#  user_id                :uuid             not null
#  daily_nerd_count       :integer
#  tracked_hours          :decimal(, )
#  billable_hours         :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  review_notes           :string
#  daily_nerd_entry_dates :datetime         default([]), not null, is an Array
#  finished_storypoints   :integer          default(0), not null
#  turnover               :decimal(, )
#  costs                  :decimal(, )
#

require "rails_helper"

RSpec.describe SprintFeedback do
  fixtures :all
  let(:feedback) { sprint_feedbacks(:sprint_feedback_1) }

  it "calculates the costs based on the current salary" do
    feedback.recalculate_costs
    salary = feedback.user.salary_at(feedback.sprint.sprint_from)
    expect(salary.brut).to eq 3800
    expect(feedback.costs).to eq 2352.38 # 10 working days, assuming 21 working days per month
  end

  it "displays revenue based on turnover and costs" do
    expect(feedback.turnover).to eq 150
    expect(feedback.revenue.to_f).to eq(-2016.67)
    expect(feedback.turnover_per_storypoint).to eq 18.75
  end
end
