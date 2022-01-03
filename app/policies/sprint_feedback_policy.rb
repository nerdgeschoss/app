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
end
