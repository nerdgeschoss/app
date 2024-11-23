# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestApp
  class Application < Rails::Application
    config.load_defaults 8.0
    config.time_zone = "Berlin"
    host = if ENV["HOST"].present?
      ENV["HOST"]
    elsif ENV["HEROKU_APP_NAME"].present?
      "https://#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
    elsif Rails.env.test?
      "http://localhost:31337" # the default capybara port
    else
      "http://localhost:3000"
    end

    config.action_mailer.default_url_options ||= {}
    config.action_mailer.default_url_options[:host] = host
    Rails.application.routes.default_url_options[:host] = host
    config.active_job.queue_adapter = :solid_queue

    config.autoload_lib(ignore: ["assets", "tasks"])
    config.generators.system_tests = nil
  end
end
