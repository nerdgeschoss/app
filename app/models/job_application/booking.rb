# frozen_string_literal: true

# The applicant's Calendly booking for whichever interview stage the application is in.
class JobApplication::Booking
  STAGES = ["interview", "craft_interview"].freeze

  attr_reader :job_application

  def initialize(job_application)
    @job_application = job_application
  end

  def stage
    job_application.status if STAGES.include?(job_application.status)
  end

  def scheduling_url
    job_application.public_send(:"#{stage}_scheduling_url")
  end

  def booked?
    stage.present? && job_application.public_send(:"#{stage}_booked_at").present?
  end

  def book!
    job_application.update!("#{stage}_booked_at": Time.current)
    job_application.publish(:"#{stage}_booked", job_application_id: job_application.id)
  end

  def reset!
    job_application.update!("#{stage}_booked_at": nil)
  end
end
