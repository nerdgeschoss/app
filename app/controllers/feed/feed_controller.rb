# frozen_string_literal: true

module Feed
  class FeedController < ActionController::Base
    include Shimmer::Localizable
    protect_from_forgery with: :null_session
  end
end
