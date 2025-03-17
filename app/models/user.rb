# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  born_on         :date
#  email           :string           default(""), not null
#  first_name      :string
#  github_handle   :string
#  hired_on        :date
#  last_name       :string
#  nick_name       :string
#  roles           :string           default([]), not null, is an Array
#  yearly_holidays :integer          default(30), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slack_id        :string
#

class User < ApplicationRecord
  include Team

  self.ignored_columns = ["encrypted_password", "reset_password_sent_at", "reset_password_token", "remember_created_at"]

  scope :alphabetically, -> { order(first_name: :asc) }
  scope :with_role, ->(role) { where("? = ANY(users.roles)", role) }
  scope :sprinter, -> { with_role("sprinter") }
  scope :hr, -> { with_role("hr") }
  scope :currently_employed, -> { where.not(roles: []) }

  has_many :payslips, dependent: :destroy
  has_many :leaves, dependent: :destroy, class_name: "Leave"
  has_many :sprint_feedbacks, dependent: :destroy
  has_many :salaries, dependent: :destroy
  has_many :task_users, dependent: :delete_all
  has_many :tasks, through: :task_users
  has_many :inventories, dependent: :destroy

  def avatar_image(size: 180)
    hash = Digest::MD5.hexdigest(email.to_s.downcase)
    "https://www.gravatar.com/avatar/#{hash}?d=mm&s=#{size}"
  end

  def display_name
    nick_name.presence || first_name.presence || email
  end

  def slack_mention_display_name
    User::SlackNotification.new(self).slack_mention_display_name
  end

  def slack_profile
    @slack_profile ||= User::SlackProfile.new(self)
  end

  def full_name
    [first_name, last_name].filter_map(&:presence).join(" ").presence || email
  end

  def remaining_holidays
    yearly_holidays - used_holidays
  end

  def unpaid_holidays_this_year
    leaves_this_year.select(&:unpaid?).map(&:days).flatten.sort_by(&:month).group_by(&:month).map do |month|
      [month.first, month.last]
    end
  end

  def unpaid_holidays_this_year_total
    unpaid_holidays_this_year.sum { |_, days| days.size }
  end

  def used_holidays
    leaves_this_year.reject(&:rejected?).select(&:paid?).flat_map(&:days).count
  end

  def notify!(message)
    User::SlackNotification.new(self).send_message message
  end

  def congratulate_on_birthday
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!,
      text: I18n.t("users.messages.happy_birthday",
        user: display_name.upcase))
  end

  def congratulate_on_hiring_anniversary
    employment_duration_text = ApplicationController.helpers.time_ago_in_words(hired_on).remove("about").strip
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!,
      text: I18n.t("users.messages.congrats", user: display_name,
        employment_duration: employment_duration_text))
  end

  def current_salary
    salaries.find(&:current?)
  end

  def salary_at(date)
    salaries.sort_by(&:valid_from).select { _1.valid_from < date }.last
  end

  private

  def leaves_this_year
    @leaves_this_year ||= begin
      date = Time.zone.today
      leaves.during(date.beginning_of_year..date.end_of_year)
    end
  end
end
