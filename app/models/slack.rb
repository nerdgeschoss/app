class Slack
  include Singleton

  def notify(channel:, text:)
    HTTParty.post(url, body: {channel: channel, text: text}.to_json, headers: headers)
  end

  private

  def url
    "https://slack.com/api/chat.postMessage"
  end

  def token
    Config.slack_token!
  end

  def headers
    {"Content-Type": "application/json", authorization: "Bearer #{token}"}
  end
end
