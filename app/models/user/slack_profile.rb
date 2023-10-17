# frozen_string_literal: true

class User
  class SlackProfile
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def set_status(type:, until_date:)
      Slack.instance.set_status(slack_id: user.ensure_slack_id!, text: type.to_s, emoji: send("#{type}_emoji"), until_date:)
    end

    private

    def sick_emoji
      ":face_with_thermometer:"
    end

    def vacation_emoji
      ":palm_tree:"
    end
  end
end
