# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_user, except: :index

  def index
    @users = policy_scope(User.alphabetically)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update permitted_attributes(@user)
      ui.navigate_to @user
    else
      render :edit
    end
  end

  def unpaid_vacation
  end

  private

  def assign_user
    @user = authorize User.find params[:id]
  end
end
