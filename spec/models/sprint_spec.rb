# frozen_string_literal: true

# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  title         :string           not null
#  sprint_during :daterange        not null
#  working_days  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Sprint do
  fixtures :all

  before do
    allow(BankHoliday::FeiertageApi.instance).to receive(:retrieve_bank_holidays).and_return(["2023-05-01", "2023-10-03"])
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
        Bank holidays: 0
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
        Bank holidays: 0

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
        Bank holidays: 0

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
        Bank holidays: 0

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
        Bank holidays: 0

        🏖️ *On leave:*

        - John is away for 11 days: (Jan 23 — Feb 4 and Feb 2)
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "mentions birthdays" do
      john.update! born_on: "1989-02-01", hired_on: "2019-04-25"
      sprint.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10
        Bank holidays: 0

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
        Bank holidays: 0

        🎈 *John celebrates their nerdgeschoss anniversary on Jan 25!*
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "mentions bank holidays" do
      allow(BankHoliday::FeiertageApi.instance).to receive(:retrieve_bank_holidays).and_return(["2023-01-24"])

      travel_to "2023-01-23"
      sprint.reload.send_sprint_start_notification
      text = <<~TEXT
        🏃 *Sprint S2023-02 starts today!*
        Duration: January 23 — February 3, 2023
        Working days: 10
        Bank holidays: Jan 24
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end
  end
end
