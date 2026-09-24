# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Booking do
  fixtures :all

  it "has no stage outside the interviews" do
    booking = described_class.new(job_applications(:max_review))
    expect(booking.stage).to be_nil
    expect(booking).not_to be_booked
  end

  it "books and resets the first interview" do
    application = job_applications(:jane_awaiting_interview)
    booking = described_class.new(application)
    expect(booking.scheduling_url).to eq application.interview_scheduling_url

    perform_enqueued_jobs { booking.book! }
    expect(application.reload.interview_booked_at).to be_present
    expect(application.events.sole).to have_attributes(name: "interview_booked")

    booking.reset!
    expect(application.reload.interview_booked_at).to be_nil
  end

  it "books the craft interview" do
    application = job_applications(:max_review)
    application.update!(status: :craft_interview, craft_interview_scheduling_url: "https://calendly.com/jensravens/call")

    perform_enqueued_jobs { described_class.new(application).book! }
    expect(application.reload.craft_interview_booked_at).to be_present
    expect(application.events.sole).to have_attributes(name: "craft_interview_booked")
  end
end
