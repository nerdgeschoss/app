# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def styleguide
    sample_user = User.new(email: "styleguide@example.com", first_name: "Jane", last_name: "Doe", nick_name: "JD", api_token: SecureRandom.base58(24))
    sprint = Sprint.new(title: "S2025-01", sprint_during: Date.new(2025, 3, 10)..Date.new(2025, 3, 21), working_days: 8)
    feedback = sprint.sprint_feedbacks.build(
      id: SecureRandom.uuid,
      user: sample_user,
      billable_hours: 38.5,
      tracked_hours: 52.0,
      finished_storypoints: 13,
      retro_rating: 4,
      retro_text: "Great sprint! We delivered all planned features.",
      daily_nerd_count: 6
    )

    render Views::Pages::Styleguide.new(sprint:, feedback:, days: feedback.days)
  end

  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.not_rejected.chronologic
    sprint_feedback = current_user.sprint_feedbacks.find_by(sprint: @sprint) if @sprint
    @daily_nerd_message = DailyNerdMessage.find_by(created_at: Time.zone.today.all_day, sprint_feedback:) || sprint_feedback.daily_nerd_messages.build if sprint_feedback
    @needs_retro_for = SprintFeedback.where(user: current_user).sprint_past.reverse_chronologic.limit(2).find { !_1.retro_completed? }
  end
end
