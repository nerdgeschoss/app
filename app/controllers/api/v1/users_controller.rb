# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def emails
        unless params[:token].present? && ActiveSupport::SecurityUtils.secure_compare(Config.api_emails_list_token!, params[:token])
          head :unauthorized
          return
        end

        emails = User.alphabetically.sprinter.pluck(:email)
        render json: {results: emails}
      end
    end
  end
end
