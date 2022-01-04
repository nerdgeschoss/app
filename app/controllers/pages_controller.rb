# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.limit(3)
  end
end
