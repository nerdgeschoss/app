# frozen_string_literal: true

module UrlGenerating
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options.merge(locale: I18n.locale)
  end
end
