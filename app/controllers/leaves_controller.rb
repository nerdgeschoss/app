# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_leave, only: [:update, :destroy]

  def index
    @leaves = policy_scope(Leave.reverse_chronologic)
    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
    @user = if params[:user].present?
      User.find(params[:user])
    else
      current_user
    end
  end

  def new
    @leave = authorize current_user.leaves.new
  end

  def create
    @leave = authorize Leave.new(permitted_attributes(Leave).merge(days: permitted_attributes(Leave)[:days].split(", ")).reverse_merge(user_id: current_user.id))
    if @leave.save
      @leave.sick? ? @leave.notify_slack_about_sick_leave : @leave.notify_hr_on_slack_about_new_request
      ui.navigate_to leaves_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def update
    if @leave.update(permitted_attributes(Leave).merge(status: permitted_attributes(Leave)[:status]))
      redirect_to leaves_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @leave.destroy!
    redirect_to leaves_path
  end

  private

  def assign_leave
    @leave = Leave.find(params[:id])
  end
end
