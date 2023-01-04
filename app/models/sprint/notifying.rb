module Sprint::Notifying
  extend ActiveSupport::Concern

  def notify_slack
    Slack.new(sprint_start_body).notify
  end

  private

  def sprint_start_body
    use_channel = Rails.env.production? ? sprint_announcement_channel : test_channel
    {channel: use_channel, text: sprint_start_content}
  end

  def sprint_announcement_channel
    Config.slack_announcement_channel_id
  end

  def test_channel
    Config.slack_test_channel_id
  end

  def sprint_start_content
    "*Sprint #{title} starts today!*\nDuration: #{ApplicationController.helpers.date_range sprint_during.min, sprint_during.max, format: :long}\nWorking days: #{working_days}\n*On leave:*\n#{leaves}"
  end

  def leaves
    text = ""
    Leave.during(sprint_during).each do |leave|
      text << "\n- #{leave.user.first_name} (#{ApplicationController.helpers.date_range leave.leave_during.min, leave.leave_during.max, format: :long}), #{leave.type}, #{leave.title}"
    end
    text
  end
end
