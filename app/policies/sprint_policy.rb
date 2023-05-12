# frozen_string_literal: true

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
