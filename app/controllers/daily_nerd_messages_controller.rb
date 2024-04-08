# frozen_string_literal: true

class DailyNerdMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_daily_nerd_message, only: [:update]

  def create
    @daily_nerd_message = authorize DailyNerdMessage.new(daily_nerd_message_attributes.merge(sprint_feedback:))
    if @daily_nerd_message.save
      @daily_nerd_message.push_to_slack
      sprint_feedback.add_daily_nerd_entry(@daily_nerd_message.created_at)
      redirect_to sprints_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def update
    @daily_nerd_message.update!(daily_nerd_message_attributes)
    redirect_to sprints_path
  end

  private

  def daily_nerd_message_attributes
    params.require(:daily_nerd_message).permit(:message)
  end

  def assign_daily_nerd_message
    @daily_nerd_message = authorize DailyNerdMessage.find(params[:id])
  end

  def sprint_feedback
    @sprint_feedback ||= current_user.sprint_feedbacks.find_by(sprint: Sprint.current.take)
  end
end