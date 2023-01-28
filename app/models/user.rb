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
#  born_on                :date
#  hired_on               :date
#

class User < ApplicationRecord
  include ActionView::Helpers::DateHelper
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
    leaves_this_year.select(&:paid?).flat_map(&:days).count
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def congratulate_on_birthday
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: I18n.t("users.messages.happy_birthday", user: slack_mention_display_name))
  end

  def congratulate_on_hiring_anniversary
    employment_duration_text = time_ago_in_words(hired_on).remove("about").strip
    Slack.instance.notify(channel: Config.slack_announcement_channel_id!, text: I18n.t("users.messages.congrats", user: slack_mention_display_name, employment_duration: employment_duration_text))
  end

  def birthday_in_actual_year
    born_on.change year: Date.current.year
  end

  def hiring_date_in_actual_year
    hired_on.change year: Date.current.year
  end

  def birthday_in_next_year
    born_on.change year: Date.current.year + 1
  end

  def hiring_date_in_next_year
    hired_on.change year: Date.current.year + 1
  end

  private

  def leaves_this_year
    @leaves_this_year ||= begin
      date = Date.today
      leaves.during(date.beginning_of_year..date.end_of_year)
    end
  end
end
