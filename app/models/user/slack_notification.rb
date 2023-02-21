# frozen_string_literal: true

class User
  class SlackNotification
    class NotificationError < StandardError; end

    attr_reader :user, :slack_id, :email

    def initialize(user)
      @user = user
      @slack_id = ensure_slack_id!
      @email = user.email
    end

    def slack_mention_display_name
      id = ensure_slack_id
      id.present? ? "<@#{id}>" : user.display_name
    end

    def send_message(message)
      Slack.instance.notify(channel: slack_id, text: message)
    end

    private

    def ensure_slack_id!
      id = ensure_slack_id
      raise NotificationError, "Could not find slack address for #{email}" if id.blank?

      id
    end

    def ensure_slack_id
      return user.slack_id if user.slack_id.present?

      id = Slack.instance.retrieve_users_slack_id_by_email(email)
      user.update! slack_id: id if id.present?
      id
    end
  end
end
