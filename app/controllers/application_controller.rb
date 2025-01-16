# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::Localizable
  include Authenticating
  include Reaction::Controller
  include Pundit::Authorization
end
