class Slack
  include Singleton

  def notify(channel:, text:)
    response = HTTParty.post(notification_url, body: {channel: channel, text: text}.to_json, headers: headers)
    raise StandardError, "Slack notification failed: #{response.body}" unless response.ok?
    binding.pry
  end

  def get_user_by_email(email)
    response = HTTParty.get(get_user_by_email_url, headers: headers, query: {email: email})
    raise StandardError, "Slack notification failed: #{response.body}" unless response.ok?
    response["user"]
  end

  def get_user_by_email(email)
    response = HTTParty.get(get_user_by_email_url, headers: headers, query: {email: email})
    raise StandardError, "Slack notification failed: #{response.body}" unless response.ok?
    response["user"]
  end

  private

  def notification_url
    "https://slack.com/api/chat.postMessage"
  end

  def get_user_by_email_url
    "https://slack.com/api/users.lookupByEmail"
  end

  def token
    Config.slack_token!
  end

  def headers
    {"Content-Type": "application/json", authorization: "Bearer #{token}"}
  end
end
