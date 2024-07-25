# frozen_string_literal: true

# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  title         :string           not null
#  sprint_during :daterange        not null
#  working_days  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Sprint < ApplicationRecord
  include RangeAccessing
  include Sprint::Harvest

  has_many :sprint_feedbacks, dependent: :delete_all
  has_many :time_entries, dependent: :delete_all

  scope :reverse_chronologic, -> { order("UPPER(sprints.sprint_during) DESC") }
  scope :active_at, ->(date) { where("?::date <@ sprints.sprint_during", date) }
  scope :start_on, ->(date) { where("?::date = LOWER(sprints.sprint_during)", date) }
  scope :before, ->(date) { where("?::date > LOWER(sprints.sprint_during)", date) }
  scope :current, -> { active_at(DateTime.current) }
  scope :within, ->(time) { where("LOWER(sprints.sprint_during) > ?", time.ago) }

  validates :title, presence: true

  range_accessor_methods :sprint

  def total_working_days
    sprint_feedbacks.sum(&:working_day_count)
  end

  def total_holidays
    sprint_feedbacks.sum(&:holiday_count)
  end

  def total_sick_days
    sprint_feedbacks.sum(&:sick_day_count)
  end

  def daily_nerd_percentage
    sprint_feedbacks.sum(&:daily_nerd_percentage) / [sprint_feedbacks.size, 1].max
  end

  def tracked_hours
    sprint_feedbacks.map(&:tracked_hours).compact.sum
  end

  def billable_hours
    sprint_feedbacks.map(&:billable_hours).compact.sum
  end

  def finished_storypoints
    sprint_feedbacks.map(&:finished_storypoints).compact.sum
  end

  def turnover_per_storypoint
    (sprint_feedbacks.map(&:turnover_per_storypoint).compact.sum / [sprint_feedbacks.size, 1].max).round(2)
  end

  def turnover
    sprint_feedbacks.map(&:turnover).compact.sum
  end

  def costs
    sprint_feedbacks.map(&:costs).compact.sum
  end

  def revenue
    turnover - costs
  end

  def completed?
    sprint_until.past?
  end

  def send_sprint_start_notification
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: Sprint::Notification.new(self).message)
  end

  def average_rating
    ratings = sprint_feedbacks.map(&:retro_rating).compact
    return nil if ratings.empty?

    ratings.sum / ratings.size.to_f
  end

  def to_be_rated?
    sprint_until.today? || completed?
  end
end
