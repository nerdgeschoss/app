# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  roles                  :string           default([]), not null, is an Array
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  slack_id               :string
#  born_on                :date
#  hired_on               :date
#

require "rails_helper"

RSpec.describe User do
  fixtures :all
  let(:john) { users(:john) }
  let(:slack_text) { Slack.instance.last_message.text }

  it "congratulates the user on his birthday" do
    john.congratulate_on_birthday
    expect(slack_text).to eq "🥳 *HAPPY BIRTHDAY JOHN!!*"
  end

  it "congratulation job calls the according method on birthdays" do
    travel_to "2023-09-30"
    SlackCongratulationJob.perform_now
    expect(slack_text).to eq "🥳 *HAPPY BIRTHDAY JOHN!!*"
  end

  it "congratulates the user on his anniversary" do
    travel_to "2023-02-02"
    john.congratulate_on_hiring_anniversary
    expect(slack_text).to eq "🎉 Congratulations John on being a part of nerdgeschoss for 3 years now!"
  end

  it "congratulation job calls the according method on birthdays" do
    travel_to "2023-01-01"
    SlackCongratulationJob.perform_now
    expect(slack_text).to eq "🎉 Congratulations John on being a part of nerdgeschoss for 3 years now!"
  end

  context "notified about a message" do
    let(:john) { users(:john_no_slack) }
    it "updates the slack id on first use" do
      expect(john).to have_attributes email: "john-no-slack@example.com", slack_id: nil
      allow(Slack.instance).to receive(:retrieve_users_slack_id_by_email).with("john-no-slack@example.com").and_return("slack-15")
      allow(Slack.instance).to receive(:notify).with(channel: "slack-15", text: "hello")

      john.notify! "hello"

      expect(john.slack_id).to eq "slack-15"
    end

    it "fails if slack doesn't recognize the email" do
      allow(Slack.instance).to receive(:retrieve_users_slack_id_by_email).with("john-no-slack@example.com").and_return(nil)
      expect { john.notify!("hello") }.to raise_error(User::SlackNotification::NotificationError)
    end

    it "uses the persisted slack id" do
      users(:john).notify!("hello")
      expect(Slack.instance.last_message).to have_attributes channel: "slack-john", text: "hello"
    end
  end
end
