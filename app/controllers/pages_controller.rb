# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.not_rejected.chronologic
    if @sprint
      sprint_feedback = current_user.sprint_feedbacks.find_or_create_by(sprint: @sprint)
      @daily_nerd_message = authorize DailyNerdMessage.find_by(created_at: Time.zone.today.all_day, sprint_feedback:) || sprint_feedback.daily_nerd_messages.build
    end
    @need_retro = current_user.sprint_feedbacks.sprint_past.retro_missing
  end

  def offline
  end
end
