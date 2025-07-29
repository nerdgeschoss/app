# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!, except: :team_overview
  before_action :assign_leave, only: [:update, :destroy]

  def index
    @user = if policy(Leave).show_all_users?
      params[:user_id].present? ? User.find(params[:user_id]) : nil
    else
      current_user
    end
    @leaves = policy_scope(@user.present? ? Leave.where(user_id: @user) : Leave.all).reverse_chronologic
    @leaves = @leaves.with_status(params[:status]&.to_sym) if params[:status].present?
    @leaves = @leaves.page(params[:page]).per(20)
    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
  end

  def new
    @leave = authorize current_user.leaves.new
  end

  def create
    @leave = authorize Leave.new(permitted_attributes(Leave).reverse_merge(user_id: current_user.id))
    @leave.save!
    @leave.handle_incoming_request
    @leave.handle_slack_status
  end

  def update
    @leave.update!(permitted_attributes(Leave))
    @leave.notify_user_on_slack_about_status_change if @leave.status_previously_changed?
    @leave.handle_slack_status
  end

  def destroy
    @leave.destroy!
  end

  # Generate the params[:team_hash] with e.g. `Rails.application.message_verifier(:team_name).generate("laic")`
  def team_overview
    team_name = Rails.application.message_verifier(:team_name).verify(params[:team_hash])

    @leaves = Leave
      .of_team(team_name)
      .during(Date.today..1.year.from_now)
      .chronologic
      .map(&:presenter)

    render layout: false
  end

  private

  def assign_leave
    @leave = authorize Leave.find(params[:id])
  end
end
