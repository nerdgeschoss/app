class SlackNotificationJob < ApplicationJob
    queue_as :import
    sidekiq_options retry: 0

    def perform
    end
end
