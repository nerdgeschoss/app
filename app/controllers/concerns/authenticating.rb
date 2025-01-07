module Authenticating
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.session = session
    end

    helper_method :current_user

    def current_user
      Current.user
    end

    def authenticate_user!
      redirect_to login_path unless current_user
    end
  end
end
