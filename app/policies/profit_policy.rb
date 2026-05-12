# frozen_string_literal: true

class ProfitPolicy < ApplicationPolicy
  def index?
    hr?
  end
end
