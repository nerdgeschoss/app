# frozen_string_literal: true

class Leave
  class RequestHandler
    attr_reader :user, :leave

    def initialize(leave:)
      @user = leave.user
      @leave = leave
    end

    def handle_request
      leave.sick? ? handle_sick_leave : handle_regular_leave
    end

    private

    def handle_sick_leave
      leave.update status: :appoved if leave.days.one?
      leave.notify_slack_about_sick_leave
    end

    def handle_regular_leave
      leave.notify_hr_on_slack_about_new_request
    end
  end
end
