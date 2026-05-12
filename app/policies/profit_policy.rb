# frozen_string_literal: true

class ProfitPolicy < ApplicationPolicy
  def show?
    hr?
  end
end
