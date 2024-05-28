# frozen_string_literal: true

# == Schema Information
#
# Table name: leaves
#
#  id           :uuid             not null, primary key
#  leave_during :daterange        not null
#  title        :string           not null
#  type         :string           default("paid"), not null
#  status       :string           default("pending_approval"), not null
#  days         :date             default([]), not null, is an Array
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
  scope :with_status, ->(status) { (status == :all) ? all : where(status:) }
  scope :starts_today, -> { where("LOWER(leaves.leave_during) = ?", Time.zone.today) }
  scope :not_rejected, -> { where.not(status: :rejected) }

  enum type: [:paid, :unpaid, :sick, :non_working].index_with(&:to_s)
  enum status: [:pending_approval, :approved, :rejected].index_with(&:to_s)

  range_accessor_methods :leave

  validates :title, :days, presence: true

  before_validation do
    start_on, end_on = days.minmax
    self.leave_during = start_on..end_on
    self.status = :approved if pending_approval? && ((type == "sick" && days.length == 1) || type == "non_working")
  end

  def presenter
    @presenter ||= Leave::Presenter.new(self)
  end

  def handle_incoming_request
    case type
    when "sick"
      notify_slack_about_sick_leave
    when "paid", "unpaid"
      notify_hr_on_slack_about_new_request
    end
  end

  def handle_slack_status
    set_slack_status! if leave_during.include?(Time.zone.today) && (approved? || sick?)
  end

  def notify_slack_about_sick_leave
    return unless days.include?(Time.zone.today)

    Slack.instance.notify(channel: Config.slack_announcement_channel_id!,
      text: Leave::Notification.new(leave: self).slack_sick_leave_message)
  end

  def notify_hr_on_slack_about_new_request
    Slack.instance.notify(channel: Config.slack_hr_channel_id!,
      text: Leave::Notification.new(leave: self).hr_leave_request_message)
  end

  def notify_user_on_slack_about_status_change
    user.notify!(Leave::Notification.new(leave: self).status_change_message)
  end

  def set_slack_status!
    emoji = Leave::Presenter.new(self).slack_emoji
    user.slack_profile.set_status(type:, emoji:, until_date: leave_during.max)
  end

  delegate :to_ics, to: :presenter
end
