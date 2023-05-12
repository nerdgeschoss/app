# frozen_string_literal: true

class SprintFeedbackPolicy < ApplicationPolicy
  def create?
    hr?
  end

  def update?
    hr?
  end

  def destroy?
    hr?
  end

  def show_group?
    hr?
  end

  def show_notes?
    hr?
  end

  class Scope < Scope
    def resolve
      if hr?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
