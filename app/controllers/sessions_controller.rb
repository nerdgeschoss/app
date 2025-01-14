# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    email = params.require(:email)
    dev_login = Rails.env.development? || Config.dev_login?
    code = dev_login ? "999999" : SecureRandom.random_number(10**6).to_s.rjust(6, "0")
    cookies.encrypted[:auth_challenge] = {
      value: [email, code],
      expires: 15.minutes.from_now,
      httponly: true
    }
    user = User.find_by(email:)
    UserMailer.login_code(user, code).deliver_later if user
    redirect_to confirm_login_path
  end

  def edit
    @email, _ = cookies.encrypted[:auth_challenge]
    redirect_to login_path unless @email.present?
  end

  def update
    email, code = cookies.encrypted[:auth_challenge]
    if code == params[:code]
      user = User.find_by!(email:)
      cookies.delete(:auth_challenge)
      Current.user = user
      redirect_to root_path
    else
      head :forbidden
    end
  end

  def destroy
    Current.user = nil
    redirect_to login_path
  end
end
