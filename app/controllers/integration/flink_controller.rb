# frozen_string_literal: true

module Integration
  class FlinkController < ApiController
    def webhook
      event = JSON.parse(request.body)
      date = event["created_at"].to_datetime
      sprint = Sprint.active_at(date).take
      feedback = sprint && sprint.sprint_feedbacks.joins(:user).where(user: {email: event.dig("author",
        "email")}).take
      feedback&.add_daily_nerd_entry(date)
      head :accepted
    rescue JSON::ParserError
      head :bad_request
    end
  end
end
