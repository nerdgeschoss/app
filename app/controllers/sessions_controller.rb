# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @login = Login.new
    render Views::Sessions::New.new(login: @login)
  end

  def create
    @login = Login.new(email: params.require(:login).permit(:email)[:email])
    @login.request_code(cookies)
    redirect_to confirm_login_path
  end

  def edit
    @login = Login.from_cookie(cookies)
    return redirect_to login_path unless @login
    render Views::Sessions::Edit.new(login: @login)
  end

  def update
    @login = Login.from_cookie(cookies)
    return redirect_to login_path unless @login
    if @login.verify(params.require(:login).permit(:code)[:code], cookies)
      Current.user = @login.user
      redirect_to root_path
    else
      render Views::Sessions::Edit.new(login: @login), status: :forbidden
    end
  end

  def destroy
    Current.user = nil
    redirect_to login_path
  end
end
