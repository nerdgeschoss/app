# frozen_string_literal: true

# == Schema Information
#
# Table name: leaves
#
#  id           :uuid             not null, primary key
#  leave_during :daterange        not null
#  title        :string           not null
#  type         :string           default("paid"), not null
#  status       :string           default("pending_approval"), not null
#  days         :date             default([]), not null, is an Array
#  user_id      :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe Leave do
  fixtures :all
  let(:user) { users(:john) }
  let(:holiday) { user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-02", "2023-01-03"] }
  let(:single_day_sick_leave) { user.leaves.create! type: :sick, title: "Sick", days: ["2023-01-02"] }

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
        You can approve or reject this request <http://localhost:31337/en/leaves?status=pending_approval&user_id=d6f57eaa-da8a-5c59-a1a1-8ebe34034b8a|here>
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

  describe "request handling" do
    let(:sick_leave) { single_day_sick_leave }
    let(:paid_leave) { holiday }
    let(:unpaid_leave) { holiday.tap { |l| l.type = "unpaid" } }

    before do
      [sick_leave, paid_leave, unpaid_leave].each do |leave|
        allow(leave).to receive(:notify_slack_about_sick_leave)
        allow(leave).to receive(:notify_hr_on_slack_about_new_request)
        allow(leave).to receive(:set_slack_status!)
      end
    end

    describe "#handle_incoming_request" do
      it "notifies slack about sick leave for sick type" do
        sick_leave.handle_incoming_request
        expect(sick_leave).to have_received(:notify_slack_about_sick_leave)
        expect(sick_leave).not_to have_received(:notify_hr_on_slack_about_new_request)
        expect(sick_leave).not_to have_received(:set_slack_status!)
      end

      it "notifies HR on slack about new request for paid type" do
        paid_leave.handle_incoming_request
        expect(paid_leave).to have_received(:notify_hr_on_slack_about_new_request)
        expect(paid_leave).not_to have_received(:notify_slack_about_sick_leave)
        expect(paid_leave).not_to have_received(:set_slack_status!)
      end

      it "notifies HR on slack about new request for unpaid type" do
        unpaid_leave.handle_incoming_request
        expect(unpaid_leave).to have_received(:notify_hr_on_slack_about_new_request)
        expect(unpaid_leave).not_to have_received(:notify_slack_about_sick_leave)
        expect(unpaid_leave).not_to have_received(:set_slack_status!)
      end
    end

    describe "#handle_slack_status" do
      it "sets slack status if leave is during today and approved" do
        paid_leave.approved!
        allow(Time.zone).to receive(:today).and_return(paid_leave.leave_during.min)
        paid_leave.handle_slack_status
        expect(paid_leave).to have_received(:set_slack_status!)
        expect(paid_leave).not_to have_received(:notify_slack_about_sick_leave)
        expect(paid_leave).not_to have_received(:notify_hr_on_slack_about_new_request)
      end

      it "does not set slack status if leave is not during today" do
        paid_leave.approved!
        allow(Time.zone).to receive(:today).and_return(paid_leave.leave_during.max + 1.day)
        paid_leave.handle_slack_status
        expect(paid_leave).not_to have_received(:set_slack_status!)
        expect(paid_leave).not_to have_received(:notify_slack_about_sick_leave)
        expect(paid_leave).not_to have_received(:notify_hr_on_slack_about_new_request)
      end

      it "does not set slack status if leave is not approved" do
        paid_leave.pending_approval!
        allow(Time.zone).to receive(:today).and_return(paid_leave.leave_during.min)
        paid_leave.handle_slack_status
        expect(paid_leave).not_to have_received(:set_slack_status!)
        expect(paid_leave).not_to have_received(:notify_slack_about_sick_leave)
        expect(paid_leave).not_to have_received(:notify_hr_on_slack_about_new_request)
      end
    end
  end
end
