# frozen_string_literal: true

source "https://rubygems.org"
ruby File.read(".ruby-version").strip

# Core
gem "puma"
gem "rails", "7.1.3"

# Database
gem "pg"

# Performance
gem "bootsnap", require: false
gem "oj"

# Extensions
gem "bcrypt"
gem "chartkick"
gem "countries", require: "countries/global"
gem "devise"
gem "document_serializable"
gem "dotenv-rails"
gem "friendly_id"
gem "groupdate"
gem "httparty"
gem "icalendar", "~> 2.4"
gem "image_processing"
gem "kaminari"
gem "mini_magick"
gem "mission_control-jobs"
gem "pundit"
gem "rails-i18n"
gem "shimmer"
gem "sitemap_generator"
gem "slim-rails"
gem "solid_queue"
gem "time_will_tell"
gem "translate_client"
gem "yael"
gem "faker"

# Assets
gem "autoprefixer-rails"
gem "jsbundling-rails"
gem "sassc-rails"
gem "serviceworker-rails"
gem "sprockets"
gem "stimulus-rails"
gem "turbo-rails"

# Services
gem "aws-sdk-s3"
gem "barnes" # enables detailed metrics within heroku
gem "newrelic_rpm"
gem "sentry-rails"
gem "sentry-ruby"

group :development, :test do
  gem "capybara"
  gem "capybara-screenshot-diff"
  gem "cuprite"
  gem "i18n-tasks"
  gem "rack_session_access"
  gem "rspec-rails"
  gem "rspec-retry"
  gem "standard"
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rake"
  gem "webmock", require: false
  gem "pundit-matchers"
end

group :development do
  gem "annotate"
  gem "debug"
  gem "guard"
  gem "guard-rspec"
  gem "letter_opener"
  gem "listen"
  gem "rb-fsevent"
  gem "web-console"
end
