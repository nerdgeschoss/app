class Current < ActiveSupport::CurrentAttributes
  attribute :session

  def user
    @user ||= User.find_by(id: session[:user_id])
  end

  def user=(user)
    session[:user_id] = user&.id
    @user = user
  end

  resets do
    @user = nil
  end
end
