# frozen_string_literal: true

class JobApplication::Rejection
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :message, :string

  attr_accessor :job_application

  validates :message, presence: true

  def save
    return false unless valid?

    from_status = job_application.status
    job_application.rejected!
    job_application.publish(:rejected, job_application_id: job_application.id, from_status:, message:)
    JobApplicationMailer.with(job_application:, text: message).rejection.deliver_later
    true
  end
end
