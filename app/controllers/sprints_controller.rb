# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sprints = policy_scope(Sprint.reverse_chronologic)
      .includes(:time_entries, :tasks, sprint_feedbacks: [:daily_nerd_messages, user: :leaves])
      .page(params[:page]).per(20)
  end

  def new
    sprint_from = Date.today.beginning_of_week(:monday)
    sprint_until = sprint_from.next_week(:sunday)
    @sprint = authorize Sprint.new(sprint_during: sprint_from..sprint_until)
  end

  def create
    @sprint = authorize Sprint.new(sprint_attributes)
    User.sprinter.each do |user|
      @sprint.sprint_feedbacks.build user:
    end
    @sprint.save!
  end

  private

  def sprint_attributes
    params.require(:sprint).permit(:title, :sprint_from, :sprint_until)
  end
end
