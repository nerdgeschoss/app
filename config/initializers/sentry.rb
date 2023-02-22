# frozen_string_literal: true

Sentry.init do |config|
  sentry_environment = Config.sentry_environment || Rails.env
  next unless Rails.env.production?

  config.dsn = "https://cd5af23b2f66400ab0248dcfd5db31b7@o385233.ingest.sentry.io/4504717892583424"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = sentry_environment
end
