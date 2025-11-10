# frozen_string_literal: true

# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  sprint_during :daterange        not null
#  title         :string           not null
#  working_days  :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Sprint < ApplicationRecord
  include RangeAccessing
  include Sprint::Harvest

  has_many :sprint_feedbacks, dependent: :delete_all
  has_many :time_entries, dependent: :delete_all
  has_many :tasks, dependent: :nullify

  scope :reverse_chronologic, -> { order("UPPER(sprints.sprint_during) DESC") }
  scope :active_at, ->(date) { where("?::date <@ sprints.sprint_during", date) }
  scope :start_on, ->(date) { where("?::date = LOWER(sprints.sprint_during)", date) }
  scope :before, ->(date) { where("?::date > LOWER(sprints.sprint_during)", date) }
  scope :current, -> { active_at(DateTime.current) }
  scope :within, ->(time) { where("LOWER(sprints.sprint_during) > ?", time.ago) }

  validates :title, presence: true

  range_accessor_methods :sprint

  def full_title
    "#{title} (#{ApplicationController.helpers.date_range(sprint_from, sprint_until, format: :long)})"
  end

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
    sprint_feedbacks.filter_map(&:tracked_hours).sum
  end

  def billable_hours
    sprint_feedbacks.filter_map(&:billable_hours).sum
  end

  def finished_storypoints
    sprint_feedbacks.filter_map(&:finished_storypoints).sum
  end

  def storypoints_per_department
    tasks.reduce(Hash.new(0.0)) do |acc, task|
      involved_teams = (task.labels & ["design", "frontend", "backend"])
      involved_teams.each do |team|
        acc[team] += task.story_points.to_f / involved_teams.size
      end
      acc
    end.map { |team, points| [team, points] }
  end

  def finished_storypoints_per_day
    (finished_storypoints.to_f / [total_working_days, 1].max).round(6)
  end

  def turnover_per_storypoint
    (sprint_feedbacks.filter_map(&:turnover_per_storypoint).sum / [sprint_feedbacks.size, 1].max).round(2)
  end

  def turnover
    sprint_feedbacks.filter_map(&:turnover).sum
  end

  def costs
    sprint_feedbacks.filter_map(&:costs).sum
  end

  def revenue
    turnover - costs
  end

  def completed?
    sprint_until.past?
  end

  def days
    sprint_during.to_a
  end

  def send_sprint_start_notification
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: Sprint::Notification.new(self).message)
  end

  def average_rating
    ratings = sprint_feedbacks.filter_map { !_1.skip_retro && _1.retro_rating }
    return 0 if ratings.empty?

    ratings.sum / ratings.size.to_f
  end
end
