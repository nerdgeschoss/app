class SlackNotificationJob < ApplicationJob
  queue_as :import
  sidekiq_options retry: 0

  def perform
    Sprint.start_at(Date.current).each do |sprint|
      sprint.notify_slack
    end
  end
end
