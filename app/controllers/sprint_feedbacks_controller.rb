# frozen_string_literal: true

class SprintFeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_feedback, except: [:create]

  def show
    @feedback = authorize SprintFeedback.includes(:user, :daily_nerd_messages, sprint: [time_entries: [:project, task_object: :time_entries]]).find params[:id]
  end

  def create
    feedback = authorize SprintFeedback.new(feedback_create_attributes)
    feedback.save!
    ui.replace feedback.sprint
  end

  def edit
  end

  def update
    if @feedback.update feedback_update_attributes
      @user = @feedback.user
      ui.close_popover
      ui.replace @feedback.sprint
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback.destroy!
    ui.close_popover
    ui.replace @feedback.sprint
  end

  private

  def assign_feedback
    @feedback = authorize SprintFeedback.find params[:id]
  end

  def feedback_create_attributes
    params.require(:sprint_feedback).permit(:user_id, :sprint_id)
  end

  def feedback_update_attributes
    params.require(:sprint_feedback).permit(policy(@feedback).permitted_attributes)
  end
end
