# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope

    protected

    def role?(role)
      user&.roles&.include?(role.to_s)
    end

    def hr?
      role?(:hr) || role?(:admin)
    end

    def employee?
      role?(:hr) || role?(:admin) || role?(:sprinter)
    end
  end

  protected

  def role?(role)
    user&.roles&.include?(role.to_s)
  end

  def hr?
    role?(:hr) || role?(:admin)
  end

  def employee?
    role?(:hr) || role?(:admin) || role?(:sprinter)
  end
end
