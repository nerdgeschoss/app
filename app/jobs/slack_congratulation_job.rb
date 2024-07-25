# frozen_string_literal: true

class SlackCongratulationJob < ApplicationJob
  queue_as :notification

  def perform
    User.currently_employed.where("EXTRACT(MONTH FROM born_on) = ? AND EXTRACT(DAY FROM born_on) = ?", Date.current.month, Date.current.day).each(&:congratulate_on_birthday)
    User.currently_employed.where("EXTRACT(MONTH FROM hired_on) = ? AND EXTRACT(DAY FROM hired_on) = ?", Date.current.month, Date.current.day).each(&:congratulate_on_hiring_anniversary)
  end
end
