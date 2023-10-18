# frozen_string_literal: true

class SlackSetStatusJob < ApplicationJob
  queue_as :notification
  sidekiq_options retry: 0

  def perform
    Leave.approved.starts_today.each do |leave|
      leave.set_slack_status
    end
  end
end
