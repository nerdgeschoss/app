# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!

  def index
    @leaves = policy_scope(Leave.reverse_chronologic)
  end

  def new
    @leave = authorize current_user.leaves.new
  end

  def create
    @leave = authorize Leave.new(permitted_attributes(Leave).merge(days: permitted_attributes(Leave)[:days].split(", ")).reverse_merge(user_id: current_user.id))
    if @leave.save
      @leave.notify_slack_about_sick_leave if @leave.sick?
      ui.navigate_to leaves_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    @leave = authorize Leave.find(params[:id])
    @leave.destroy!
    redirect_to leaves_path
  end
end
