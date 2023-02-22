# frozen_string_literal: true

class SlackNotificationJob < ApplicationJob
  queue_as :notification
  sidekiq_options retry: 0

  def perform
    Sprint.start_on(Date.current).each(&:send_sprint_start_notification)
  end
end
