# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :cookies
  attribute :api_token

  def user
    @user ||= if cookies.encrypted[:auth]
      User.find_by(id: cookies.encrypted[:auth])
    elsif api_token
      User.find_by(api_token:)
    end
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
