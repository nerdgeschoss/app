# frozen_string_literal: true

class Leave
  class Notification
    include UrlGenerating
    attr_reader :user, :leave

    def initialize(leave:)
      @user = leave.user
      @leave = leave
    end

    def hr_leave_request_message
      I18n.t("leaves.notifications.new_request_content",
        user: user.slack_mention_display_name,
        leave_during: formatted_leave_during,
        link: user_request_link_markdown,
        type: leave.type)
    end

    def slack_sick_leave_message
      I18n.t("leaves.notifications.sick_leave_content",
        user: user.slack_mention_display_name,
        leave_during: formatted_leave_during,
        count: leave.days.size)
    end

    def status_change_message
      I18n.t("leaves.notifications.status_change_content",
        user: user.display_name,
        leave_during: formatted_leave_during,
        status: leave.status,
        type: leave.type)
    end

    private

    def user_request_link_markdown
      url = leaves_url(user_id: user, status: :pending_approval)
      "<#{url}|#{I18n.t("leaves.notifications.here")}>"
    end

    def formatted_leave_during
      ApplicationController.helpers.date_range leave.leave_during.min, leave.leave_during.max, format: :long
    end
  end
end
