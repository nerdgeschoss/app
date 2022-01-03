# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
  end
end
