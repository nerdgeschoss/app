# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :build_login, only: [:new, :create, :edit, :update]

  def new
    render Views::Sessions::New.new(login: @login)
  end

  def create
    @login.email = params.require(:login).permit(:email)[:email]
    if @login.valid?
      @login.request_code
      redirect_to confirm_login_path
    else
      render Views::Sessions::New.new(login: @login), status: :unprocessable_entity
    end
  end

  def edit
    return redirect_to login_path unless @login.email.present?
    render Views::Sessions::Edit.new(login: @login)
  end

  def update
    return redirect_to login_path unless @login.email.present?
    @login.code = params.require(:login).permit(:code)[:code]
    if @login.verify
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

  private

  def build_login
    @login = Login.new(cookies:)
  end
end
