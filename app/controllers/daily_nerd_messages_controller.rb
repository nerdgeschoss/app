# frozen_string_literal: true

class DailyNerdMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_daily_nerd_message, only: [:update, :edit]

  def show
    sprint = Sprint.current.take
    sf = current_user.sprint_feedbacks.find_by(sprint:) if sprint
    daily_nerd_message = if sf
      DailyNerdMessage.find_by(created_at: Time.zone.today.all_day, sprint_feedback: sf) || sf.daily_nerd_messages.build
    end

    render Views::DailyNerdMessages::Show.new(daily_nerd_message:), layout: false
  end

  def edit
    render Views::DailyNerdMessages::Edit.new(daily_nerd_message: @daily_nerd_message), layout: false
  end

  def create
    @daily_nerd_message = authorize DailyNerdMessage.new(daily_nerd_message_attributes.merge(sprint_feedback:))
    @daily_nerd_message.save!
    SlackPostDailyNerdJob.perform_later(daily_nerd_message: @daily_nerd_message)
    sprint_feedback.add_daily_nerd_entry(@daily_nerd_message.created_at)
    ui.navigate_to root_path
  end

  def update
    @daily_nerd_message.update!(daily_nerd_message_attributes)
    ui.navigate_to root_path
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
