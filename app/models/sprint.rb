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

  has_many :sprint_feedbacks
  has_many :time_entries

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
        feedback.update! tracked_hours: feedback_entries.sum(:hours), billable_hours: feedback_entries.billable.sum(:hours)
      end
    end
  end

  def send_sprint_start_notification
    lines = leaves_text_lines
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text:
        I18n.t("sprints.notifications.sprint_start_content",
          title: title,
          sprint_during: ApplicationController.helpers.date_range(sprint_during.min, sprint_during.max, format: :long),
          working_days: working_days,
          leaves: lines,
          count: lines.size)
              .concat("\n", birthdays_text_lines, anniversaries_text_lines))
  end

  def leaves_text_lines
    Leave.includes(:user).during(sprint_during).map do |leave|
      "\n- #{leave.user.slack_mention_display_name} (#{ApplicationController.helpers.date_range leave.leave_during.min, leave.leave_during.max, format: :long}): #{leave.title} (#{leave.type})"
    end.join
  end

  def birthdays_text_lines
    all_users.select { |user| sprint_during.cover?(user.birthday_in_actual_year) || sprint_during.cover?(user.birthday_in_next_year) if user.born_on.present? }.map do |user|
      I18n.t("sprints.notifications.birthday_line", user: user.slack_mention_display_name, date: user.born_on&.strftime("%d.%m."))
    end.join
  end

  def anniversaries_text_lines
    all_users.select { |user| sprint_during.cover?(user.hiring_date_in_actual_year) || sprint_during.cover?(user.hiring_date_in_next_year) if user.hired_on.present? }.map do |user|
      I18n.t("sprints.notifications.anniversary_line", user: user.slack_mention_display_name, date: user.hired_on.strftime("%d.%m."))
    end.join
  end

  def all_users
    User.all
  end
end
