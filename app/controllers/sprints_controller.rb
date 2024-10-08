# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :authenticate_user!

  def index
    @metric = SprintMetrics::METRICS.include?(params[:metric]&.to_sym) ? params[:metric].to_sym : :billable_per_day
    @sprints = policy_scope(Sprint.reverse_chronologic)
      .includes(sprint_feedbacks: [user: :leaves])
      .page(params[:page]).per(20)
    @sprinters = User.sprinter.to_a
    @user = if params[:user].present?
      User.find(params[:user])
    elsif policy(SprintFeedback).show_group?
      nil
    else
      current_user
    end
  end

  def new
    @sprint = authorize Sprint.new working_days: 10, sprint_from: Time.zone.today, sprint_until: 11.days.from_now
  end

  def create
    @sprint = authorize Sprint.new(sprint_attributes)
    User.sprinter.each do |user|
      @sprint.sprint_feedbacks.build user:
    end
    if @sprint.save
      ui.navigate_to sprints_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  private

  def sprint_attributes
    params.require(:sprint).permit(:title, :sprint_from, :sprint_until, :working_days)
  end
end
