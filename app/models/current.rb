# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :cookies

  def user
    @user ||= User.find_by(id: cookies.encrypted[:auth])
  end

  def user=(user)
    if user
      cookies.encrypted[:auth] = {value: user&.id, httponly: true, expires: 3.months.from_now}
    else
      cookies.delete(:auth)
    end
    @user = user
  end

  resets do
    @user = nil
  end
end
