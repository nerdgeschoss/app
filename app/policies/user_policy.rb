# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    employee?
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

  def unpaid_vacation?
    hr? || user == record
  end

  def financial_details?
    hr? || user == record
  end

  def permitted_attributes
    [:first_name, :last_name, :nick_name]
  end

  class Scope < Scope
    def resolve
      if hr?
        scope.all
      elsif employee?
        scope.currently_employed
      elsif user
        scope.where(id: user.id)
      else
        scope.none
      end
    end
  end
end
