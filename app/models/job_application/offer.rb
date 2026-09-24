# frozen_string_literal: true

# Offers the applicant a position at the level HR settled on.
class JobApplication::Offer
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :offered_level, :string
  attribute :message, :string

  attr_accessor :job_application

  validates :offered_level, inclusion: {in: JobApplication.offered_levels.keys}
  validates :message, presence: true

  def save
    return false unless valid?

    job_application.update!(status: :job_offer, offered_level:)
    job_application.publish(:offered, job_application_id: job_application.id, offered_level:, message:)
    JobApplicationMailer.with(job_application:, text: message).offer.deliver_later
    true
  end
end
