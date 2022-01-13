# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sprints = policy_scope(Sprint.reverse_chronologic)
  end

  def new
    @sprint = authorize Sprint.new working_days: 10, sprint_from: Date.today, sprint_until: 11.days.from_now
  end

  def create
    sprint = authorize Sprint.new(sprint_attributes)
    sprint.save!
    ui.navigate_to sprints_path
  end

  private

  def sprint_attributes
    params.require(:sprint).permit(:title, :sprint_from, :sprint_until, :working_days)
  end
end
