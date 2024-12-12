# frozen_string_literal: true

class Slack
  class NetworkError < StandardError; end
  Message = Struct.new(:channel, :text, keyword_init: true)
  Status = Struct.new(:slack_id, :text, :until_time, keyword_init: true)
  include Singleton

  attr_accessor :debug, :last_message, :last_slack_status_update

  def configured?
    Config.slack_bot_token.present?
  end

  def notify(channel:, text:)
    return @last_message = Message.new(channel:, text:) if debug
    return unless configured?

    request http_method: :post, slack_method: "chat.postMessage", body: {channel:, text:}.to_json
  end

  def post_personalized_message_to_daily_nerd_channel(user:, message:)
    # This is the old way of posting to slack on behalf of a user using a webhook.
    # https://api.slack.com/legacy/custom-integrations/messaging/webhooks
    # It might be necessary to change this in the future to use the new Slack API.
    request_hook url: Config.slack_webhook_url!, body: personalized_webhook_body(user:, message:, channel: "the-daily-nerd").to_json
  end

  def retrieve_users_slack_id_by_email(email)
    response = request http_method: :get, slack_method: "users.lookupByEmail", query: {email:}
    response.dig("user", "id")
  end

  def retrieve_users_profile_image_url_by_email(email)
    response = request http_method: :get, slack_method: "users.lookupByEmail", query: {email:}
    response.dig("user", "profile", "image_72")
  end

  def set_status(slack_id:, emoji:, text:, until_time:)
    return @last_slack_status_update = Status.new(slack_id:, text:, until_time:) if debug

    body = {user: slack_id, profile: {status_text: text, status_emoji: emoji, status_expiration: until_time.to_i}}.to_json
    request http_method: :post, slack_method: "users.profile.set", body:, token_type: :user
  end

  private

  def request(http_method:, slack_method:, query: nil, body: nil, token_type: :bot)
    return unless configured?

    token = Config.public_send("slack_#{token_type}_token!")
    headers = {"Content-Type": "application/json", authorization: "Bearer #{token}"}
    response = HTTParty.public_send(http_method, "https://slack.com/api/#{slack_method}", headers:, query:, body:)

    raise NetworkError, response["error"].humanize unless response.ok?

    response
  end

  def request_hook(url:, body:)
    response = HTTParty.post(url, headers: {"Content-Type": "application/json"}, body:)
    raise NetworkError, response unless response.ok?

    response
  end

  def personalized_webhook_body(user:, message:, channel:)
    {
      channel:,
      username: user.display_name,
      icon_url: user.slack_profile.image_url,
      text: message
    }
  end
end
