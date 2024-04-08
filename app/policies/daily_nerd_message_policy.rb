# frozen_string_literal: true

class DailyNerdMessagePolicy < ApplicationPolicy
  def home?
    hr? || users_own_message?
  end

  def create?
    hr? || users_own_message?
  end

  def update?
    hr? || users_own_message?
  end

  def users_own_message?
    user == record.sprint_feedback.user
  end
end