# frozen_string_literal: true

class Leave
  class RequestHandler
    attr_reader :leave

    def initialize(leave:)
      @leave = leave
    end

    def call
      leave.sick? ? handle_sick_leave : handle_regular_leave
    end

    private

    def handle_sick_leave
      leave.days.one? ? leave.update!(status: :appoved) : leave.notify_hr_on_slack_about_new_request
    end

    def handle_regular_leave
      leave.notify_hr_on_slack_about_new_request
    end
  end
end
