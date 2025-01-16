# frozen_string_literal: true

# == Schema Information
#
# Table name: leaves
#
#  id           :uuid             not null, primary key
#  days         :date             default([]), not null, is an Array
#  leave_during :daterange        not null
#  status       :string           default("pending_approval"), not null
#  title        :string           not null
#  type         :string           default("paid"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#

require "rails_helper"

RSpec.describe Leave do
  fixtures :all
  let(:user) { users(:john) }
  let(:holiday) { user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-02", "2023-01-03"] }
  let(:single_day_sick_leave) { user.leaves.create! type: :sick, title: "Sick", days: ["2023-01-02"] }

  around do |example|
    Config.stub(slack_announcement_channel_id: "slack-announcement-channel", slack_bot_token: "BOT_TOKEN", slack_hr_channel_id: "HR_CHANNEL") do
      example.run
    end
  end

  describe "auto-approving" do
    it "works for single day sick leaves" do
      expect(holiday).to be_pending_approval
      expect(single_day_sick_leave).to be_approved
    end

    it "works for non-working days" do
      leave = user.leaves.create! type: :non_working, title: "Non-working", days: ["2023-01-02"]
      expect(leave).to be_approved
    end
  end

  context "sending notifications" do
    it "requests a leave from HR" do
      holiday.notify_hr_on_slack_about_new_request
      text = <<~TEXT
        *<@slack-john>* requested a new paid leave for January 2 — 3, 2023
        You can approve or reject this request <http://example.com/en/leaves?status=pending_approval&user_id=d6f57eaa-da8a-5c59-a1a1-8ebe34034b8a|here>
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "notifies a user about an approved vacation" do
      holiday.update! status: :approved
      holiday.notify_user_on_slack_about_status_change
      text = <<~TEXT
        Hi, *John*!
        Your paid leave request for January 2 — 3, 2023 has been approved.
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "notifies a user about a rejected vacation" do
      holiday.update! status: :rejected
      holiday.notify_user_on_slack_about_status_change
      text = <<~TEXT
        Hi, *John*!
        Your paid leave request for January 2 — 3, 2023 has been rejected.
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "notifies the announcement channel about sick leaves on the same day" do
      single_day_sick_leave.notify_slack_about_sick_leave
      expect(Slack.instance.last_message).to be_nil

      travel_to "2023-01-02"
      single_day_sick_leave.notify_slack_about_sick_leave
      text = <<~TEXT
        *<@slack-john> is on sick leave today*
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end
  end

  context "Slack status" do
    before do
      allow(Slack.instance).to receive(:set_status)
      holiday.update! status: :approved
    end

    describe "on the first day of leave" do
      before do
        travel_to "2023-01-02"
        SlackSetStatusJob.perform_now
      end

      it "sets the Slack status once" do
        expect(Slack.instance).to have_received(:set_status).once.with(
          slack_id: "slack-john",
          text: "On vacation",
          emoji: ":beach_with_umbrella:",
          until_time: Time.zone.parse("2023-01-03").end_of_day
        )
      end
    end

    describe "on any other day of leave" do
      before do
        travel_to "2023-01-03"
        SlackSetStatusJob.perform_now
      end

      it "does not set the Slack status" do
        expect(Slack.instance).not_to have_received(:set_status)
      end
    end
  end

  describe "#handle_incoming_request" do
    before do
      [single_day_sick_leave, holiday].each do |leave|
        allow(leave).to receive(:notify_slack_about_sick_leave)
        allow(leave).to receive(:notify_hr_on_slack_about_new_request)
      end
    end

    it "notifies slack about sick leave for sick type" do
      single_day_sick_leave.handle_incoming_request

      expect(single_day_sick_leave).to have_received(:notify_slack_about_sick_leave)
      expect(single_day_sick_leave).not_to have_received(:notify_hr_on_slack_about_new_request)
    end

    it "notifies HR on slack about new request for paid type" do
      holiday.handle_incoming_request

      expect(holiday).to have_received(:notify_hr_on_slack_about_new_request)
      expect(holiday).not_to have_received(:notify_slack_about_sick_leave)
    end

    it "notifies HR on slack about new request for unpaid type" do
      unpaid_holiday = holiday.tap { |l| l.type = "unpaid" }

      unpaid_holiday.handle_incoming_request

      expect(unpaid_holiday).to have_received(:notify_hr_on_slack_about_new_request)
      expect(unpaid_holiday).not_to have_received(:notify_slack_about_sick_leave)
    end
  end

  describe "#handle_slack_status" do
    before do
      [single_day_sick_leave, holiday].each do |leave|
        allow(leave).to receive(:set_slack_status!)
      end
    end

    it "sets slack status if leave is during today and approved" do
      holiday.approved!
      travel_to holiday.leave_during.min

      holiday.handle_slack_status

      expect(holiday).to have_received(:set_slack_status!)
    end

    it "does not set slack status if leave is not during today" do
      holiday.approved!
      travel_to holiday.leave_during.max + 1.day

      holiday.handle_slack_status

      expect(holiday).not_to have_received(:set_slack_status!)
    end

    it "does not set slack status if leave is not approved" do
      holiday.pending_approval!
      travel_to holiday.leave_during.min

      holiday.handle_slack_status

      expect(holiday).not_to have_received(:set_slack_status!)
    end
  end
end
