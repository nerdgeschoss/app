# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  def index?
    hr?
  end

  def show?
    hr?
  end

  class Scope < Scope
    def resolve
      if hr?
        scope.all
      else
        scope.none
      end
    end
  end
end
