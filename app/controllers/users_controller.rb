# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_user, except: :index

  def index
    @filter = params[:filter].presence_in(Views::Users::Index::FILTERS) || "employee"
    @users = policy_scope(User.alphabetically)
    @hide_financials = !policy(User).financial_details?
    case @filter
    when "employee"
      @users = @users.currently_employed
    when "sprinter"
      @users = @users.sprinter
    when "hr"
      @users = @users.hr
    when "archive"
      @users = @users.where(roles: [])
    end
    @users = @users.includes(:salaries, :leaves_this_year) unless @hide_financials
    render Views::Users::Index.new(users: @users, hide_financials: @hide_financials)
  end

  def show
    @salaries = @user.salaries.chronologic
    @inventories = @user.inventories
    @hide_financials = !policy(@user).financial_details?
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
    @unpaid_vacation = @user.unpaid_holidays_this_year
  end

  private

  def assign_user
    @user = authorize User.find params[:id]
  end
end
