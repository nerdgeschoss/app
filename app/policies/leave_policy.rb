class LeavePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    hr?
  end

  def permitted_attributes
    attr = [:title, :days, :type]
    attr += [:user_id] if hr?
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
