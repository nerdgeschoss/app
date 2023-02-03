class SlackCongratulationJob < ApplicationJob
  queue_as :notification
  sidekiq_options retry: 0

  def perform
    User.currently_employed.where(born_on: Date.current).each(&:congratulate_on_birthday)
    User.currently_employed.where(hired_on: Date.current).each(&:congratulate_on_hiring_anniversary)
  end
end
