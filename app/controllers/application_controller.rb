# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::Localizable
  include Reaction::Controller
  include Pundit::Authorization
end
