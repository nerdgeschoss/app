# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  roles                  :string           default([]), not null, is an Array
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  slack_id               :string
#  born_on                :date
#  hired_on               :date
#  github_handle          :string
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
