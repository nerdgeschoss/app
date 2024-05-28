# frozen_string_literal: true

class SlackPostDailyNerdJob < ApplicationJob
  queue_as :notification
  sidekiq_options retry: 0

  def perform(daily_nerd_message:)
    daily_nerd_message.post_to_slack
  end
end
