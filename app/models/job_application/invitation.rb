# frozen_string_literal: true

# Invites an application to its next interview stage.
class JobApplication::Invitation
  include ActiveModel::Model
  include ActiveModel::Attributes

  NEXT_STAGES = {"review" => "interview", "interview" => "craft_interview"}.freeze

  attribute :scheduling_url, :string
  attribute :message, :string

  attr_accessor :job_application

  validates :scheduling_url, :message, presence: true

  def stage
    NEXT_STAGES[job_application.status]
  end

  def save
    return false unless valid?

    stage = self.stage
    job_application.update!(status: stage, "#{stage}_scheduling_url": scheduling_url)
    job_application.publish(:"#{stage}_invited", job_application_id: job_application.id, scheduling_url:, message:)
    JobApplicationMailer.with(job_application:, text: message).public_send(:"#{stage}_invitation").deliver_later
    true
  end
end
