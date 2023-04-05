# frozen_string_literal: true

module Feed
  class LeavesController < FeedController
    before_action :require_login

    def index
      @leaves = Leave.all
      respond_to :ics
    end

    private

    def require_login
      current_user = User.find_by id: params[:auth] if params[:auth].present?
      head :unauthorized unless current_user&.roles&.include?("hr")
    end
  end
end
