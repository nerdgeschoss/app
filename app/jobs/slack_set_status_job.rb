# frozen_string_literal: true

class SlackSetStatusJob < ApplicationJob
  queue_as :notification

  def perform
    Leave.approved.starts_today.each(&:set_slack_status!)
  end
end
