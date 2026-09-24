# frozen_string_literal: true

class JobApplication
  module Hiring
    extend ActiveSupport::Concern

    def hire!
      user = transaction do
        # Applicants type their address by hand; users.email is case-sensitive.
        user = User.find_by("LOWER(email) = LOWER(?)", email) || User.new(email:, first_name:, last_name:, github_handle:)
        user.roles = ["sprinter"] if user.roles.empty?
        user.update!(hired_on: available_from || Date.current)
        update!(status: :hired, user:)
        user
      end
      publish(:hired, job_application_id: id, user_id: user.id)
      user
    end
  end
end
