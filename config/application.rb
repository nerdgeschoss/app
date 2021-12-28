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
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = "Berlin"

    config.middleware.use Shimmer::CloudflareProxy

    config.action_mailer.default_url_options = {host: ENV["HOST"]} if ENV["HOST"].present?
    config.active_job.queue_adapter = :sidekiq

    config.assets.paths << Rails.root.join("node_modules")
  end
end
