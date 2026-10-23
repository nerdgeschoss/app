# frozen_string_literal: true

class LeavePolicy < ApplicationPolicy
  def update?
    hr? || (record.user == user && (record.leave_during.max >= Time.zone.today))
  end

  def destroy?
    hr? || (record.user == user && record.leave_during.min > 1.week.from_now)
  end

  def hr_overview?
    hr?
  end

  def approve?
    hr? && record.pending_approval?
  end

  def permitted_attributes
    attr = [:title, :type]
    attr += [:status] if hr?
    attr += [days: []]
    attr
  end
end
