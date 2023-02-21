# frozen_string_literal: true

class User
  class SlackNotification
    class NotificationError < StandardError; end

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def slack_mention_display_name
      "<@#{slack_id}>"
    rescue NotificationError
      user.display_name
    end

    def send_message(message)
      Slack.instance.notify(channel: slack_id, text: message)
    end

    private

    def slack_id
      return user.slack_id if user.slack_id.present?

      slack_id = Slack.instance.retrieve_users_slack_id_by_email(user.email)
      raise NotificationError, "Could not find slack address for #{user.email}" if slack_id.blank?
      user.update!(slack_id:)
      slack_id
    end
  end
end
