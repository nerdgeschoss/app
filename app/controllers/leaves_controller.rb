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
    leave = authorize current_user.leaves.build(leave_attributes.merge(days: leave_attributes[:days].split(", ")))
    leave.save!
    ui.navigate_to leaves_path
  end

  def destroy
    @leave = authorize Leave.find(params[:id])
    @leave.destroy!
    redirect_to leaves_path
  end

  private

  def leave_attributes
    params.require(:leave).permit(:title, :days, :type)
  end
end
