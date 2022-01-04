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
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  scope :alphabetically, -> { order(first_name: :asc) }

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

  def full_name
    [first_name, last_name].map(&:presence).compact.join(" ").presence || email
  end

  def yearly_holidays
    30
  end

  def remaining_holidays
    yearly_holidays - used_holidays
  end

  def used_holidays
    leaves_this_year.flat_map(&:days).count
  end

  private

  def leaves_this_year
    @leaves_this_year ||= begin
      date = Date.today
      leaves.during(date.beginning_of_year..date.end_of_year)
    end
  end
end
