# frozen_string_literal: true

# == Schema Information
#
# Table name: sprint_feedbacks
#
#  id                     :uuid             not null, primary key
#  billable_hours         :decimal(, )
#  costs                  :decimal(, )
#  daily_nerd_count       :integer
#  daily_nerd_entry_dates :datetime         default([]), not null, is an Array
#  finished_storypoints   :integer          default(0), not null
#  retro_rating           :integer
#  retro_text             :string
#  review_notes           :string
#  skip_retro             :boolean          default(FALSE)
#  tracked_hours          :decimal(, )
#  turnover               :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sprint_id              :uuid             not null
#  user_id                :uuid             not null
#

require "rails_helper"

RSpec.describe SprintFeedback do
  fixtures :all
  let(:feedback) { sprint_feedbacks(:sprint_feedback_john) }

  context "when calculating costs" do
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

  context "when calculating days" do
    # sprint_during: '[2023-01-23, 2023-02-03]'

    before do
      feedback.user.leaves.create! type: :non_working, title: "Loveparade", days: ["2023-01-23"]
      feedback.user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-24"], status: :approved
      feedback.user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-25"], status: :pending_approval
      feedback.user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-26"], status: :rejected
      feedback.user.leaves.create! type: :sick, title: "Sick", days: ["2023-01-27"]
    end

    it "takes all non rejected leave types into account" do
      expect(feedback.working_day_count).to eq feedback.sprint.working_days - 4
    end

    it "does not count rejected leaves" do
      expect(feedback.holiday_count).to eq 2
    end
  end
end
