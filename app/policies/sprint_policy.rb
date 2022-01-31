class SprintPolicy < ApplicationPolicy
  def create?
    hr?
  end

  def destroy?
    hr?
  end

  def overview?
    hr?
  end
end
