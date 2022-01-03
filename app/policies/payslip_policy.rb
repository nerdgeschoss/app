class PayslipPolicy < ApplicationPolicy
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
        scope.where(user_id: user.id)
      end
    end
  end
end
