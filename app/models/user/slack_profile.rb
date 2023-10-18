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
      return slack_id if slack_id.present?

      id = Slack.instance.retrieve_users_slack_id_by_email(email)
      raise NoSlackIdError, "Could not find slack address for #{email}" if id.blank?
      update!(slack_id: id)
      id
    end
  end
end
