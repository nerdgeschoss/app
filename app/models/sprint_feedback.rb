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

class SprintFeedback < ApplicationRecord
  belongs_to :sprint
  belongs_to :user

  scope :ordered, -> { joins(:user).order("users.email ASC") }

  before_validation do
    recalculate_costs if costs.nil?
  end

  def daily_nerd_percentage
    daily_nerd_count.to_f / working_day_count
  end

  def billable_hours_percentage
    billable_hours.to_f / [0.01, tracked_hours.to_f].max
  end

  def billable_per_day
    billable_hours.to_f / working_day_count
  end

  def tracked_per_day
    tracked_hours.to_f / [working_day_count, 1].max
  end

  def working_day_count
    sprint.working_days - [holiday_count, sick_day_count, non_working_day_count].sum
  end

  def holiday_count
    @holiday_count ||= count_days(:paid) + count_days(:unpaid)
  end

  def sick_day_count
    @sick_day_count ||= count_days :sick
  end

  def non_working_day_count
    @non_working_day_count ||= count_days :non_working
  end

  def add_daily_nerd_entry(timestamp)
    self.daily_nerd_entry_dates |= [timestamp]
    self.daily_nerd_count = daily_nerd_entry_dates.length
    save!
  end

  def recalculate_costs
    salary = user.salary_at(sprint.sprint_from)
    return unless salary

    self.costs = (sprint.working_days * salary.brut * 1.3 / 21.0).round(2) # assume 30% arbeitgeberkosten and 21 workdays per month
  end

  def revenue
    return nil if costs.nil? || turnover.nil?

    turnover - costs
  end

  def turnover_per_storypoint
    return nil if turnover.nil? || finished_storypoints.zero? || working_day_count.zero?

    (turnover / finished_storypoints.to_d).round(2)
  end

  def turnover_per_storypoint_against_avarage
    return nil if turnover_per_storypoint.nil?

    turnover_per_storypoint / sprint.turnover_per_storypoint
  end

  private

  def leaves
    @leaves ||= user.leaves.select { _1.leave_during.overlaps?(sprint.sprint_during) }
  end

  def count_days(status)
    leaves.select { |e| e.public_send("#{status}?") }
      .flat_map(&:days).count { |e| sprint.sprint_during.include? e }
  end
end
