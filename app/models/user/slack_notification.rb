# frozen_string_literal: true

class User::SlackNotification
  class NotificationError < StandardError; end

  attr_reader :user, :slack_id, :email

  def initialize(user)
    @user = user
    @slack_id = user.slack_id
    @email = user.email
  end

  def slack_mention_display_name
    id = ensure_slack_id
    id.present? ? "<@#{id}>" : user.display_name
  end

  def send_message(message)
    Slack.instance.notify(channel: ensure_slack_id!, text: message)
  end

  private

  def ensure_slack_id!
    id = ensure_slack_id
    raise NotificationError, "Could not find slack address for #{email}" unless id.present?
    id
  end

  def ensure_slack_id
    return slack_id if slack_id.present?

    slack_id = Slack.instance.retrieve_users_slack_id_by_email(email)
    user.update! slack_id: slack_id if slack_id.present?
    slack_id
  end
end
