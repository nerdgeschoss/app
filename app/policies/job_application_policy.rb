# frozen_string_literal: true

class JobApplicationPolicy < ApplicationPolicy
  def index?
    hr?
  end

  def show?
    true
  end

  def invite?
    hr? && (record.review? || record.interview?)
  end

  def reject?
    hr? && (record.review? || record.interview? || record.craft_interview?)
  end

  def hire?
    hr? && record.craft_interview?
  end

  # Like `show?`, the token is the authorization: the applicant books their own slot.
  def book?
    JobApplication::Booking.new(record).stage.present?
  end

  class Scope < Scope
    def resolve
      hr? ? scope.all : scope.none
    end
  end
end
