# frozen_string_literal: true

class Slack
  class NetworkError < StandardError; end
  Message = Struct.new(:channel, :text, keyword_init: true)
  include Singleton

  attr_accessor :debug, :last_message

  def notify(channel:, text:)
    return @last_message = Message.new(channel:, text:) if debug

    request http_method: :post, slack_method: "chat.postMessage", body: {channel:, text:}.to_json
  end

  def retrieve_users_slack_id_by_email(email)
    response = request http_method: :get, slack_method: "users.lookupByEmail", query: {email:}
    response.dig("user", "id")
  end

  def set_status(slack_id:, emoji:, text:, until_time:)
    body = {user: slack_id, profile: {status_text: text, status_emoji: emoji, status_expiration: until_time.to_i}}.to_json
    request http_method: :post, slack_method: "users.profile.set", body:, token_type: :user
  end

  private

  def request(http_method:, slack_method:, query: nil, body: nil, token_type: :bot)
    token = Config.public_send("slack_#{token_type}_token!")
    headers = {"Content-Type": "application/json", authorization: "Bearer #{token}"}
    response = HTTParty.public_send(http_method, "https://slack.com/api/#{slack_method}", headers:,
      query:, body:)
    raise NetworkError, response["error"].humanize unless response.ok?

    response
  end
end
