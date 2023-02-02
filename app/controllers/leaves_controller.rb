# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_leave, only: [:update, :destroy]

  def index
    @leaves = policy_scope(Leave.reverse_chronologic)
    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
    @user = params[:user_id].presence&.then { |id| User.find(id) } || current_user
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
    @leave.update!(leave_attributes)
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

  def leave_attributes
    permitted_attributes(Leave)
  end
end
