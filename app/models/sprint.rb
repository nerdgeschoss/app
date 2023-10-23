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

  has_many :sprint_feedbacks, dependent: :delete_all
  has_many :time_entries, dependent: :delete_all

  scope :reverse_chronologic, -> { order("UPPER(sprints.sprint_during) DESC") }
  scope :active_at, ->(date) { where("?::date <@ sprints.sprint_during", date) }
  scope :start_on, ->(date) { where("?::date = LOWER(sprints.sprint_during)", date) }
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

  def bank_holidays
    BankHoliday.weekday_dates_in_years(sprint_during.map(&:year).uniq).select { |date| sprint_during.cover?(date) }
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

  def sync_with_harvest
    user_ids_by_email = User.pluck(:email, :id).to_h
    harvest_entries = HarvestApi.instance.time_entries(from: sprint_from, to: sprint_until)
    deleted_ids = time_entries.pluck(:external_id) - harvest_entries.map(&:id)
    entries = harvest_entries.map do |e|
      next if user_ids_by_email[e.user].nil?

      {
        external_id: e.id,
        created_at: e.date,
        hours: e.hours,
        rounded_hours: e.rounded_hours,
        billable: e.billable,
        project_name: e.project,
        client_name: e.client,
        task: e.task,
        billable_rate: e.billable_rate,
        cost_rate: e.cost_rate,
        notes: e.notes,
        user_id: user_ids_by_email[e.user]
      }
    end
    transaction do
      time_entries.where(id: deleted_ids).delete_all if deleted_ids.any?
      time_entries.upsert_all(entries, unique_by: :external_id) if entries.any?
      sprint_feedbacks.each do |feedback|
        feedback_entries = time_entries.where(user_id: feedback.user_id)
        feedback.update! tracked_hours: feedback_entries.sum(:hours),
          billable_hours: feedback_entries.billable.sum(:hours),
          turnover: feedback_entries.billable.sum("time_entries.billable_rate * time_entries.rounded_hours")
      end
    end
  end

  def send_sprint_start_notification
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: Sprint::Notification.new(self).message)
  end
end
