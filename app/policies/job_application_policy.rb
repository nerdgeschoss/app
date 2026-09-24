# frozen_string_literal: true

class JobApplicationPolicy < ApplicationPolicy
  def index?
    hr?
  end

  def show?
    true
  end

  def invite?
    hr? && record.review?
  end

  def reject?
    hr? && record.review?
  end

  class Scope < Scope
    def resolve
      hr? ? scope.all : scope.none
    end
  end
end
