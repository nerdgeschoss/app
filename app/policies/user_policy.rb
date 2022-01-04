class UserPolicy < ApplicationPolicy
  def show?
    hr? || user == record
  end

  def create?
    hr?
  end

  def destroy?
    hr?
  end

  class Scope < Scope
    def resolve
      if hr?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
