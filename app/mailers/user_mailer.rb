# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def login_code(user, code)
    @code = code
    @user = user
    mail(to: user.email)
  end
end
