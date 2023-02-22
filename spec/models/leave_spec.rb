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

RSpec.describe Leave do
  fixtures :all
  let(:user) { users(:john) }
  let(:holiday) { user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-02"] }
  let(:single_day_sick_leave) { user.leaves.create! type: :sick, title: "Sick", days: ["2023-01-02"] }

  it "single day sick leaves are automatically approved" do
    expect(holiday).to be_pending_approval
    expect(single_day_sick_leave).to be_approved
  end

  context "sending notifications" do
    it "requests a leave from HR" do
      holiday.notify_hr_on_slack_about_new_request
      text = <<~TEXT
        *<@slack-john>* requested a new paid leave for January 2, 2023
        You can approve or reject this request <http://localhost:31337/en/leaves?status=pending_approval&user_id=d6f57eaa-da8a-5c59-a1a1-8ebe34034b8a|here>
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "notifies a user about an approved vacation" do
      holiday.update! status: :approved
      holiday.notify_user_on_slack_about_status_change
      text = <<~TEXT
        Hi, *John*!
        Your paid leave request for January 2, 2023 has been approved.
      TEXT
      expect(Slack.instance.last_message.text).to eq text.strip
    end

    it "notifies a user about a rejected vacation" do
      holiday.update! status: :rejected
      holiday.notify_user_on_slack_about_status_change
      text = <<~TEXT
        Hi, *John*!
        Your paid leave request for January 2, 2023 has been rejected.
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
end
