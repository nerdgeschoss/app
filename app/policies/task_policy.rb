# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def index?
    employee?
  end

  def show?
    employee?
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
