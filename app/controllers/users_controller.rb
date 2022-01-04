# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = policy_scope(User.alphabetically)
  end

  def show
    @user = authorize User.find params[:id]
  end
end
