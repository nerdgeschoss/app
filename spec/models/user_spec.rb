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

require "rails_helper"

RSpec.describe User do
  fixtures :all
  let(:john) { users(:john) }
  let(:slack_text) { Slack.instance.last_message.text }

  around do |example|
    Config.stub(slack_announcement_channel_id: "slack-announcement-channel") do
      example.run
    end
  end

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

  it "congratulation job calls the according method on hiring anniversaries" do
    travel_to Time.zone.local(2023, 1, 1, 12, 0, 0) do
      SlackCongratulationJob.perform_now
      expect(slack_text).to eq "🎉 Congratulations John on being a part of nerdgeschoss for 3 years now!"
    end
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
      expect { john.notify!("hello") }.to raise_error(User::SlackProfile::NoSlackIdError)
    end

    it "uses the persisted slack id" do
      users(:john).notify!("hello")
      expect(Slack.instance.last_message).to have_attributes channel: "slack-john", text: "hello"
    end
  end

  describe "#display_name" do
    it "returns the nick name if present" do
      john.nick_name = "Johnny Boy"
      expect(john.display_name).to eq "Johnny Boy"
    end

    it "returns the first name if present and the nick name is nil" do
      john.nick_name = nil
      expect(john.display_name).to eq "John"
    end

    it "returns the email if no name is present" do
      john.nick_name = nil
      john.first_name = nil
      expect(john.display_name).to eq "john@example.com"
    end
  end

  describe "Teams" do
    it "can be a team lead" do
      john.roles = ["team-lead-nerdgeschoss", "sprinter"]
      expect(john.team_lead_for).to eq ["nerdgeschoss"]
    end

    it "can be a team member" do
      john.roles = ["sprinter", "team-nerdgeschoss", "team-lead-frontend"]
      expect(john.team_member_of).to eq ["nerdgeschoss"]

      john.save!
      expect(User.in_team("nerdgeschoss")).to include(john)
    end
  end
end
