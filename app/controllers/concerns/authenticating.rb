# frozen_string_literal: true

module Authenticating
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.cookies = cookies
      Current.api_token = request.headers["Authorization"]&.split("Bearer ")&.last
    end

    helper_method :current_user

    def current_user
      Current.user
    end

    def authenticate_user!
      # This controller is also used by MissionControl, so we need the `main_app` here.
      redirect_to main_app.login_path unless current_user
    end
  end
end
