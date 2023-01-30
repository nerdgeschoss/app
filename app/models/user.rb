# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  roles                  :string           default("{}"), not null, is an Array
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  slack_address          :string
#

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  scope :alphabetically, -> { order(first_name: :asc) }
  scope :with_role, ->(role) { where("? = ANY(users.roles)", role) }
  scope :sprinter, -> { with_role("sprinter") }
  scope :hr, -> { with_role("hr") }

  has_many :payslips, dependent: :destroy
  has_many :leaves, dependent: :destroy, class_name: "Leave"
  has_many :sprint_feedbacks, dependent: :destroy

  def avatar_image(size: 180)
    hash = Digest::MD5.hexdigest(email.to_s.downcase)
    "https://www.gravatar.com/avatar/#{hash}?d=mm&s=#{size}"
  end

  def display_name
    first_name.presence || email
  end

  def slack_mention_display_name
    slack_address.present? ? "<@#{slack_address}>" : display_name
  end

  def full_name
    [first_name, last_name].map(&:presence).compact.join(" ").presence || email
  end

  def yearly_holidays
    30
  end

  def remaining_holidays
    yearly_holidays - used_holidays
  end

  def unpaid_holidays_this_year
    leaves_this_year.select(&:unpaid?).map(&:days).flatten.sort_by(&:month).group_by(&:month).map { |month| [month.first, month.last] }
  end

  def unpaid_holidays_this_year_total
    unpaid_holidays_this_year.sum { |_, days| days.size }
  end

  def used_holidays
    leaves_this_year.reject(&:rejected?).select(&:paid?).flat_map(&:days).count
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def notify(message)
    if slack_address.present?
      Slack.instance.notify(channel: slack_address, text: message)
    else
      slack_id = Slack.instance.retrieve_users_slack_id_by_email(email)
      raise StandardError, "Could not find slack address for #{email}" unless slack_id.present?

      update! slack_address: slack_id
      Slack.instance.notify(channel: slack_id, text: message)
    end
  end

  private

  def leaves_this_year
    @leaves_this_year ||= begin
      date = Date.today
      leaves.during(date.beginning_of_year..date.end_of_year)
    end
  end
end
