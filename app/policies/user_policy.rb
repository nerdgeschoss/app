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

  def update?
    hr? || user == record
  end

  def permitted_attributes
    [:first_name, :last_name, :password, :password_confirmation]
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
