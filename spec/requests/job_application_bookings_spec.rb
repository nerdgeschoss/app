# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Job application bookings" do
  fixtures :all

  it "books and resets an interview without a login" do
    application = job_applications(:jane_awaiting_interview)

    post "/en/job_applications/#{application.token}/booking"
    expect(response).to redirect_to "/en/job_applications/#{application.token}"
    expect(application.reload.interview_booked_at).to be_present

    delete "/en/job_applications/#{application.token}/booking"
    expect(application.reload.interview_booked_at).to be_nil
  end

  it "refuses an application that is not at an interview" do
    expect { post "/en/job_applications/#{job_applications(:max_review).token}/booking" }.to raise_error Pundit::NotAuthorizedError
  end
end
