# frozen_string_literal: true

class LeavePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    hr?
  end

  def update?
    hr?
  end

  def show_all_users?
    hr?
  end

  def permitted_attributes
    attr = [:title, :days, :type]
    attr += [:user_id, :status] if hr?
    attr
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
