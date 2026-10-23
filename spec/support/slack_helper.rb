# frozen_string_literal: true

module SlackHelper
  def last_slack_message
    perform_enqueued_jobs
    Slack.instance.last_message
  end
end

RSpec.configure do |config|
  config.around do |example|
    Slack.instance.debug = true
    Slack.instance.last_message = nil
    example.run
  end
  config.include SlackHelper, type: :system
  config.include SlackHelper, type: :model
end
