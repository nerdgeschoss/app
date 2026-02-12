# frozen_string_literal: true

class TimeEntryPolicy < ApplicationPolicy
  def financial_details?
    hr?
  end

  class Scope < Scope
    def resolve
      if employee?
        scope.all
      else
        scope.none
      end
    end
  end
end
