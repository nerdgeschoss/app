# frozen_string_literal: true

# == Schema Information
#
# Table name: daily_nerd_messages
#
#  id                 :uuid             not null, primary key
#  message            :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sprint_feedback_id :uuid             not null
#
class DailyNerdMessage < ApplicationRecord
  belongs_to :sprint_feedback

  validates :message, presence: true

  def post_to_slack
    User::SlackNotification.new(sprint_feedback.user).post_daily_nerd_message(message)
  end
end
