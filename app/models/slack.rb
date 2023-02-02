class Slack
  class NetworkResponseError < StandardError; end

  class NotificationError < StandardError; end
  include Singleton

  def notify(channel:, text:)
    post method: "chat.postMessage", channel: channel, text: text
  end

  def retrieve_users_slack_id_by_email(email)
    response = get method: "users.lookupByEmail", query: {email: email}
    response.dig("user", "id")
  end

  def get(method:, query:)
    response = HTTParty.get(client_url(method), headers: headers, query: query)
    raise NetworkResponseError, response["error"].humanize unless response.ok? # doesn't catch the error if the email is not found to allow nil, only catches bad network requests

    response
  end

  def post(method:, channel:, text:)
    response = HTTParty.post(client_url(method), headers: headers, body: {channel: channel, text: text}.to_json)
    raise NotificationError, response["error"].humanize unless response["ok"] == true

    response
  end

  private

  def client_url(method)
    "https://slack.com/api/#{method}"
  end

  def token
    Config.slack_token!
  end

  def headers
    {"Content-Type": "application/json", authorization: "Bearer #{token}"}
  end
end
