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
#  retro_rating           :integer
#  retro_text             :string
#  finished_storypoints   :integer          default(0), not null
#

class SprintFeedback < ApplicationRecord
  belongs_to :sprint
  belongs_to :user

  validates :retro_rating, numericality: {only_integer: true, in: 1..5}, allow_nil: true

  scope :ordered, -> { joins(:user).order("users.email ASC") }
  scope :retro_missing, -> { where(retro_rating: nil) }
  scope :sprint_past, -> { joins(:sprint).where("UPPER(sprints.sprint_during) <= ?", DateTime.current) }

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
    sprint.working_days - holiday_count - sick_day_count
  end

  def holiday_count
    @holiday_count ||= count_days(:paid) + count_days(:unpaid)
  end

  def sick_day_count
    @sick_day_count ||= count_days :sick
  end

  def add_daily_nerd_entry(timestamp)
    self.daily_nerd_entry_dates |= [timestamp]
    self.daily_nerd_count = daily_nerd_entry_dates.length
    save!
  end

  def retro_filled_out?
    retro_rating.present? && retro_text.present?
  end

  def retro_missing?
    !retro_filled_out?
  end

  private

  def leaves
    @leaves ||= user.leaves.during(sprint.sprint_during)
  end

  def count_days(status)
    leaves.select { |e| e.public_send("#{status}?") }
      .flat_map(&:days).count { |e| sprint.sprint_during.include? e }
  end
end
