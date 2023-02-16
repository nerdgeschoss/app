class Slack
  class NetworkResponseError < StandardError; end

  class SlackError < StandardError; end
  include Singleton

  def notify(channel:, text:)
    request http_method: :post, slack_method: "chat.postMessage", body: {channel: channel, text: text}.to_json
  end

  def retrieve_users_slack_id_by_email(email)
    response = request http_method: :get, slack_method: "users.lookupByEmail", query: {email: email}
    response.dig("user", "id")
  end

  def request(http_method:, slack_method:, query: nil, body: nil)
    response = HTTParty.public_send(http_method, "https://slack.com/api/#{slack_method}", headers: headers, query: query, body: body)
    raise NetworkResponseError, response["error"].humanize unless response.ok?

    response
  end

  private

  def token
    Config.slack_token!
  end

  def headers
    {"Content-Type": "application/json", authorization: "Bearer #{token}"}
  end
end
