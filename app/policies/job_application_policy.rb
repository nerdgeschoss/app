# frozen_string_literal: true

class JobApplicationPolicy < ApplicationPolicy
  def index?
    hr?
  end

  def show?
    hr?
  end

  class Scope < Scope
    def resolve
      hr? ? scope.all : scope.none
    end
  end
end
