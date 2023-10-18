# frozen_string_literal: true

class SlackSetStatusJob < ApplicationJob
  queue_as :notification
  sidekiq_options retry: 0

  def perform
    Leave.approved.starts_today.each do |leave|
      leave.user.slack_profile.set_status(type: leave.sick? ? "sick" : "vacation", until_date: leave.leave_during.max)
    end
  end
end
