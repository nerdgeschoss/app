# frozen_string_literal: true

# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  sprint_during :daterange        not null
#  title         :string           not null
#  working_days  :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Sprint do
  fixtures :all

  around do |example|
    Config.stub(slack_announcement_channel_id: "slack-announcement-channel", slack_bot_token: "BOT_TOKEN", slack_hr_channel_id: "HR_CHANNEL") do
      example.run
    end
  end

  context "sending the start notification" do
    let(:sprint) { sprints(:empty) }
    let(:john) { users(:john) }

    it "prints the details" do
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "mentions people on leave" do
      john.leaves.create! type: :paid, title: "Mallorca", days: [Date.new(2023, 2, 1)]
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🏖️ *On leave:*

        - John is away for 1 days: (Feb 1)
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "displays the correct number of days" do
      john.leaves.create! type: :paid, title: "Mallorca", days: (Date.new(2023, 2, 1)..Date.new(2023, 2, 28)).to_a
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🏖️ *On leave:*

        - John is away for 3 days: (Feb 1 — 28)
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "displays the correct number of days, taking the weekend into account" do
      john.leaves.create! type: :paid, title: "Mallorca", days: (Date.new(2023, 1, 23)..Date.new(2023, 2, 4)).to_a
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🏖️ *On leave:*

        - John is away for 10 days: (Jan 23 — Feb 4)
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "displays multiple leaves in one sprint correctly" do
      john.leaves.create! type: :paid, title: "Mallorca", days: (Date.new(2023, 1, 23)..Date.new(2023, 2, 4)).to_a
      john.leaves.create! type: :paid, title: "Mallorca", days: [Date.new(2023, 2, 2)]
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🏖️ *On leave:*

        - John is away for 11 days: (Jan 23 — Feb 4 and Feb 2)
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "does not display rejected leaves" do
      john.leaves.create! type: :paid, title: "Mallorca", days: [Date.new(2023, 2, 1)], status: :rejected
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "mentions birthdays" do
      travel_to "2023-01-23"
      john.update! born_on: "1989-02-01", hired_on: "2019-04-25"
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🎂 *John celebrates their birthday on Feb 01!*
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "mentions anniversaries" do
      travel_to "2023-01-23"
      john.update! hired_on: "2019-01-25"
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10

        🎈 *John celebrates their nerdgeschoss anniversary on Jan 25!*
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end
  end

  describe "#average_rating" do
    it "returns the average sprint rating" do
      sprint = sprints(:empty)

      expect(sprint.average_rating).to eq 4.0
    end
  end
end
