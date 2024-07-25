# frozen_string_literal: true

class InventoryPolicy < ApplicationPolicy
  def show?
    hr? || user == record.user
  end

  def create?
    hr?
  end

  def destroy?
    hr?
  end

  def update?
    hr?
  end

  def permitted_attributes
    [:name, :details, :received_at, :returned_at, :user_id]
  end
end
