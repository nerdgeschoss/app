# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_leave, only: [:update, :destroy]

  def index
    @leaves = params[:user_id].present? ? (authorize Leave.where(user_id: params[:user_id]).reverse_chronologic) : policy_scope(Leave.reverse_chronologic)
    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
    @user = if params[:user_id].present?
      User.find(params[:user_id])
    elsif policy(Leave).show_all_users?
      nil
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
    @leave.update!(permitted_attributes(Leave))
    @leave.notify_user_on_slack_about_status_change if @leave.status_previously_changed?
    redirect_to leaves_path
  end

  def destroy
    @leave.destroy!
    redirect_to leaves_path
  end

  private

  def assign_leave
    @leave = authorize Leave.find(params[:id])
  end
end
