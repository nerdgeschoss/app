# frozen_string_literal: true

class Slack
  class NetworkError < StandardError; end
  include Singleton

  def notify(channel:, text:)
    request http_method: :post, slack_method: "chat.postMessage", body: {channel:, text:}.to_json
  end

  def retrieve_users_slack_id_by_email(email)
    response = request http_method: :get, slack_method: "users.lookupByEmail", query: {email:}
    response.dig("user", "id")
  end

  private

  def request(http_method:, slack_method:, query: nil, body: nil)
    response = HTTParty.public_send(http_method, "https://slack.com/api/#{slack_method}", headers:,
      query:, body:)
    raise NetworkError, response["error"].humanize unless response.ok?

    response
  end

  def token
    Config.slack_token!
  end

  def headers
    {"Content-Type": "application/json", authorization: "Bearer #{token}"}
  end
end
