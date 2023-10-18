# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_leave, only: [:update, :destroy]

  def index
    @user = if policy(Leave).show_all_users?
      params[:user_id].present? ? User.find(params[:user_id]) : nil
    else
      current_user
    end
    @leaves = policy_scope(@user.present? ? Leave.where(user_id: @user) : Leave.all).reverse_chronologic
    @leaves = @leaves.with_status(params[:status]&.to_sym) if params[:status].present?
    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
  end

  def new
    @leave = authorize current_user.leaves.new
  end

  def create
    @leave = authorize Leave.new(permitted_attributes(Leave).merge(days: permitted_attributes(Leave)[:days].split(", ")).reverse_merge(user_id: current_user.id))
    if @leave.save
      @leave.sick? ? @leave.notify_slack_about_sick_leave : @leave.notify_hr_on_slack_about_new_request
      @leave.set_slack_status! if @leave.leave_during.include?(Time.zone.today)
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
