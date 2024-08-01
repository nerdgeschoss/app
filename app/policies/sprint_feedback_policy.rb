# frozen_string_literal: true

class SprintFeedbackPolicy < ApplicationPolicy
  def show?
    record.user == user || hr?
  end

  def create?
    hr?
  end

  def update?
    hr? || record.user == user
  end

  def destroy?
    hr?
  end

  def show_group?
    hr?
  end

  def show_notes?
    hr?
  end

  def permitted_attributes
    if hr?
      [:daily_nerd_count, :tracked_hours, :billable_hours, :review_notes, :skip_retro]
    else
      [:retro_rating, :retro_text, :skip_retro]
    end
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
