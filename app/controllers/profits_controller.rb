# frozen_string_literal: true

class ProfitsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :profit
    @years = ((Date.current.year - 4)..Date.current.year).to_a.reverse
    @year = @years.include?(params[:year].to_i) ? params[:year].to_i : Date.current.year
    range_end = (@year == Date.current.year) ? Date.current : Date.new(@year, 12, 31)
    @months = ProfitCalculation.new(Date.new(@year, 1, 1)..range_end).months
  end
end
