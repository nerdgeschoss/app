# frozen_string_literal: true

class User
  class SlackProfile
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def set_status(type:, emoji:, until_date:)
      Slack.instance.set_status(slack_id: ensure_slack_id!, text: I18n.t(".#{type}_status_text"), emoji:, until_time: until_date.to_time.end_of_day)
    end

    def ensure_slack_id!
      return user.slack_id if user.slack_id.present?

      id = Slack.instance.retrieve_users_slack_id_by_email(user.email)
      raise NoSlackIdError, "Could not find slack address for #{user.email}" if id.blank?
      user.update!(slack_id: id)
      id
    end
  end
end
