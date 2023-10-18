# frozen_string_literal: true

class User
  class SlackNotification
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def slack_mention_display_name
      "<@#{slack_id}>"
    rescue NoSlackIdError
      user.display_name
    end

    def send_message(message)
      Slack.instance.notify(channel: slack_id, text: message)
    end

    private

    def slack_id
      user.slack_profile.ensure_slack_id!
    end
  end
end
