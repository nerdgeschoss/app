# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sprints = policy_scope(Sprint.reverse_chronologic)
      .page(params[:page]).per(20)

    render Views::Sprints::Index.new(
      sprints: @sprints,
      permit_create_sprint: policy(Sprint).create?
    )
  end

  def card
    @sprint = authorize Sprint.includes(:time_entries, sprint_feedbacks: [:daily_nerd_messages, user: :leaves]).find(params[:id]), :show?
    render Views::Sprints::Card.new(
      sprint: @sprint,
      show_financials: current_user.role?(:hr),
      display_mode: params[:display] || "performance"
    ), layout: false
  end

  def new
    @sprint = authorize Sprint.new(working_days: 10, sprint_from: Time.zone.today, sprint_until: 11.days.from_now)
    render Views::Sprints::New.new(sprint: @sprint), layout: false
  end

  def create
    @sprint = authorize Sprint.new(sprint_attributes)
    User.sprinter.each do |user|
      @sprint.sprint_feedbacks.build user:
    end
    @sprint.save!
    ui.navigate_to sprints_path
  end

  private

  def sprint_attributes
    params.require(:sprint).permit(:title, :sprint_from, :sprint_until, :working_days)
  end
end
