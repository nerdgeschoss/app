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
require "rails_helper"

RSpec.describe DailyNerdMessage do
  fixtures :all
  let(:user) { users(:john) }
  let(:daily_nerd_message) { user.sprint_feedbacks.take.daily_nerd_messages.create(message: "I'm a daily nerd") }

  describe "#post_to_slack" do
    it "posts the daily nerd message to Slack" do
      slack_notification = instance_double("User::SlackNotification")
      allow(User::SlackNotification).to receive(:new).with(user).and_return(slack_notification)
      expect(slack_notification).to receive(:post_daily_nerd_message).with(daily_nerd_message.message)

      daily_nerd_message.post_to_slack
    end
  end
end
