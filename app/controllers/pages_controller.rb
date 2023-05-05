# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.chronologic
    @need_retro = current_user.sprint_feedbacks.sprint_past.retro_missing
  end

  def offline
  end
end
