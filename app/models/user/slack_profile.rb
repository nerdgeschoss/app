# frozen_string_literal: true

class User
  class SlackProfile
    class NoSlackIdError < StandardError; end

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def set_status(type:, emoji:, until_date:)
      # i18n-tasks-use t("users.slack_profile.paid_status_text")
      # i18n-tasks-use t("users.slack_profile.sick_status_text")
      # i18n-tasks-use t("users.slack_profile.unpaid_status_text")
      # i18n-tasks-use t("users.slack_profile.non_working_status_text")
      Slack.instance.set_status(slack_id: ensure_slack_id!, text: I18n.t("users.slack_profile.#{type}_status_text"), emoji:, until_time: until_date.end_of_day)
    end

    def ensure_slack_id!
      return user.slack_id if user.slack_id.present?

      id = Slack.instance.retrieve_users_slack_id_by_email(user.email)
      raise NoSlackIdError, "Could not find slack address for #{user.email}" if id.blank?
      user.update!(slack_id: id)
      id
    end

    def image_url
      Slack.instance.retrieve_users_profile_image_url_by_email(user.email)
    end
  end
end
