# frozen_string_literal: true

class SlackPostDailyNerdJob < ApplicationJob
  queue_as :notification

  def perform(daily_nerd_message:)
    daily_nerd_message.post_to_slack
  end
end
