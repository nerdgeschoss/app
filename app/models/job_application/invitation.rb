# frozen_string_literal: true

# Invites an application in review to its first interview.
class JobApplication::Invitation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :scheduling_url, :string
  attribute :message, :string

  attr_accessor :job_application

  validates :scheduling_url, :message, presence: true

  def save
    return false unless valid?

    job_application.update!(status: :interview, interview_scheduling_url: scheduling_url)
    job_application.publish(:interview_invited, job_application_id: job_application.id, scheduling_url:, message:)
    JobApplicationMailer.with(job_application:, text: message).interview_invitation.deliver_later
    true
  end
end
