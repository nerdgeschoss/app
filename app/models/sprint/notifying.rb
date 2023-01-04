module Sprint::Notifying
  extend ActiveSupport::Concern

  def notify_slack
    Slack.new(sprint_start_body).notify
  end

  private

  def sprint_start_body
    {channel: sprint_announcement_channel, text: sprint_start_content}
  end

  def sprint_announcement_channel
    "C04HE5KDLCT"
  end

  def test_channel
    "C04H4PPG52A"
  end

  def sprint_start_content
    "*Sprint #{title} starts today!*\nDuration: #{sprint_during}\nWorking days: #{working_days}\n*On leave:*\n#{leaves}"
  end

  def leaves
    text = ""
    Leave.during(sprint_during).each do |leave|
      text << "\n- #{leave.user.first_name} (#{leave.leave_during}), #{leave.type}, #{leave.title}"
    end
    text
  end
end
