# frozen_string_literal: true

class LeavesController < ApplicationController
  before_action :authenticate_user!, except: :team_overview
  before_action :assign_leave, only: [:edit, :update, :destroy]
  before_action :assign_user, only: [:index, :new, :create]

  def index
    authorize @user, :leaves?

    @year = params[:year].present? ? params[:year].to_i : nil
    @month = params[:month].present? ? params[:month].to_i : nil

    date_range = if @year.present? && @month.present?
      Date.new(@year, @month).all_month
    elsif @year.present?
      Date.new(@year).all_year
    end

    @leaves = @user.leaves.reverse_chronologic
    @leaves = @leaves.during(date_range) if date_range.present?
    @leaves = @leaves.with_status(params[:status]&.to_sym) if params[:status].present?
    @leaves = @leaves.page(params[:page]).per(20)

    @status = Leave.statuses.value?(params[:status]&.to_s) ? params[:status].to_sym : :all
    @day_counts = @user.tally_leave_days(date_range || Time.zone.today.all_year)
  end

  def new
    authorize @user, :leaves?

    @leave = @user.leaves.new
  end

  def create
    authorize @user, :leaves?

    @leave = @user.leaves.new(permitted_attributes(Leave))
    @leave.save!
    @leave.handle_incoming_request
    @leave.handle_slack_status
  end

  def edit
    @user = @leave.user
  end

  def update
    @leave.handle_update(permitted_attributes(Leave))
    # @leave.notify_user_on_slack_about_status_change if @leave.status_previously_changed?
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

    response.headers.delete "X-Frame-Options"
    render layout: false
  end

  private

  def assign_leave
    @leave = authorize Leave.find(params[:id])
  end

  def assign_user
    @user = User.find(params[:user_id])
  end
end
