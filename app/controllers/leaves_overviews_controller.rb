# frozen_string_literal: true

class LeavesOverviewsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize Leave, :hr_overview?

    @users = User.currently_employed.alphabetically

    @date = if params[:year].present? && params[:month].present?
      Date.new(params[:year].to_i, params[:month].to_i)
    else
      Time.zone.today
    end
    @month = @date.all_month

    @leaves = Leave.not_rejected.during(@month)
    @day_counts = @users.index_with { it.tally_leave_days(@month) }

    @pending_leaves = Leave.includes(:user)
      .pending_approval
      .by_urgency
      .where(type: params.fetch(:pending_leave_type, "paid"))
    @pending_leaves_counts = Leave.pending_approval.group(:type).count
  end
end
