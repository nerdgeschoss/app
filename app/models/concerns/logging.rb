# frozen_string_literal: true

module Logging
  extend ActiveSupport::Concern

  delegate :logger, to: :class

  class_methods do
    attr_writer :logger

    def logger
      @logger ||= Rails.logger
    end
  end
end
