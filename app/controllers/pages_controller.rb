# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.chronologic
    @needs_to_fill_out_retro = current_user.sprint_feedbacks.find_by(sprint: Sprint.before(@sprint.sprint_during.begin).reverse_chronologic.first).retro_missing?
  end

  def offline
  end
end
