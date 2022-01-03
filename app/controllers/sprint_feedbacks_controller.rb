# frozen_string_literal: true

class SprintFeedbacksController < ApplicationController
  before_action :authenticate_user!

  def create
    feedback = authorize SprintFeedback.new(feedback_create_attributes)
    feedback.save!
    ui.replace feedback.sprint
  end

  def edit
    @feedback = authorize SprintFeedback.find params[:id]
  end

  def update
    feedback = authorize SprintFeedback.find params[:id]
    feedback.update! feedback_update_attributes
    ui.close_modal
    ui.replace feedback.sprint
  end

  private

  def feedback_create_attributes
    params.require(:sprint_feedback).permit(:user_id, :sprint_id)
  end

  def feedback_update_attributes
    params.require(:sprint_feedback).permit(:daily_nerd_count, :tracked_hours, :billable_hours)
  end
end
