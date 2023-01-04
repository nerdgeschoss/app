class Slack
  attr_accessor :body

  def initialize(body)
    @body = body
  end

  def notify
    HTTParty.post(url, body: body.to_json, headers: headers)
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
