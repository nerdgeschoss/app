# frozen_string_literal: true

class SprintFeedbackPolicy < ApplicationPolicy
  def show?
    record.user == user || hr? || team_lead?
  end

  def create?
    hr?
  end

  def edit_retro?
    update?
  end

  def update_retro?
    update?
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
      [:daily_nerd_count, :tracked_hours, :billable_hours, :review_notes, :retro_rating, :retro_text, :skip_retro]
    else
      [:retro_rating, :retro_text, :skip_retro]
    end
  end

  class Scope < Scope
    def resolve
      if hr?
        scope.all
      elsif user.team_lead_for.any?
        users = User.in_team(user.team_lead_for)
        scope.where(user_id: users)
      else
        scope.where(user_id: user.id)
      end
    end
  end

  private

  def team_lead?
    user.team_lead_of?(record.user)
  end
end
