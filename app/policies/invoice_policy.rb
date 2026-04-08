# frozen_string_literal: true

class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if hr?
        scope.all
      else
        scope.none
      end
    end
  end
end
