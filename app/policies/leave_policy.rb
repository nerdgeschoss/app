# frozen_string_literal: true

class LeavePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    hr? || (record.user == user && record.leave_during.min > 1.week.from_now)
  end

  def update?
    hr?
  end

  def show_all_users?
    hr?
  end

  def permitted_attributes
    attr = [:title, :type]
    attr += [:user_id, :status] if hr?
    attr += [days: []]
    attr
  end

  def approve?
    record.pending_approval? && hr?
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
