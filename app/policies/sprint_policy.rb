# frozen_string_literal: true

class SprintPolicy < ApplicationPolicy
  def show?
    employee?
  end

  def create?
    hr?
  end

  def destroy?
    hr?
  end

  def overview?
    hr?
  end

  def show_revenue?
    hr?
  end

  def financial_details?
    hr?
  end

  class Scope < Scope
    def resolve
      if employee?
        scope.all
      else
        scope.none
      end
    end
  end
end
