# == Schema Information
#
# Table name: leaves
#
#  id           :uuid             not null, primary key
#  leave_during :daterange        not null
#  title        :string           not null
#  type         :string           default("paid"), not null
#  status       :string           default("pending_approval"), not null
#  days         :date             default("{}"), not null, is an Array
#  user_id      :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Leave < ApplicationRecord
  include Rails.application.routes.url_helpers
  include RangeAccessing

  self.inheritance_column = nil

  belongs_to :user

  scope :chronologic, -> { order("UPPER(leaves.leave_during) ASC") }
  scope :reverse_chronologic, -> { order("UPPER(leaves.leave_during) DESC") }
  scope :during, ->(range) { where("leaves.leave_during && daterange(?, ?)", range.min, range.max) }
  scope :future, -> { where("UPPER(leaves.leave_during) > NOW()") }
  scope :with_status, ->(status) { status == :all ? all : where(status: status) }

  enum type: [:paid, :unpaid, :sick].index_with(&:to_s)
  enum status: [:pending_approval, :approved, :rejected].index_with(&:to_s)

  range_accessor_methods :leave

  validates :title, :days, presence: true

  before_validation do
    start_on, end_on = days.minmax
    self.leave_during = start_on..end_on
  end

  def emoji
    if paid?
      "\u{1F3D6}"
    elsif unpaid?
      "\u{1F3D5}"
    else
      "\u{1F912}"
    end
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::Date.new leave_during.min
    event.dtstart.ical_params = {"VALUE" => "DATE"}
    event.dtend = Icalendar::Values::Date.new leave_during.max + 1.day
    event.dtend.ical_params = {"VALUE" => "DATE"}
    event.summary = "#{user.display_name}: #{title} #{emoji} (#{status})"
    event.url = Rails.application.routes.url_helpers.leaves_url(id: id)
    event
  end

  def notify_slack_about_sick_leave
    return unless days.include?(Date.today)
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: Leave::Notification.new(leave: self).slack_sick_leave_message)
  end

  def notify_hr_on_slack_about_new_request
    Slack.instance.notify(channel: Config.slack_hr_channel_id!, text: Leave::Notification.new(leave: self).hr_sick_leave_message)
  end

  def notify_user_on_slack_about_status_change
    user.notify!(Leave::Notification.new(leave: self).status_change_message)
  end
end
