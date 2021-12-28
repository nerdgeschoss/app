# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::Localizable
  include Shimmer::RemoteNavigation

  before_action :check_locale
end
