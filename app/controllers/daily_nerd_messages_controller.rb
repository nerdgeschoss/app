# frozen_string_literal: true

class DailyNerdMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_daily_nerd_message, only: [:update]

  def create
    @daily_nerd_message = authorize DailyNerdMessage.new(daily_nerd_message_attributes.merge(sprint_feedback:))
    @daily_nerd_message.save!
    SlackPostDailyNerdJob.perform_later(daily_nerd_message: @daily_nerd_message)
    sprint_feedback.add_daily_nerd_entry(@daily_nerd_message.created_at)
  end

  def update
    @daily_nerd_message.update!(daily_nerd_message_attributes)
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
