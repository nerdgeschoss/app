# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication do
  fixtures :all

  it "refreshes open pages once yael has stored an event" do
    application = job_applications(:max_review)
    allow(described_class).to receive(:find).with(application.id).and_return(application)
    allow(application).to receive(:broadcast_refresh)

    perform_enqueued_jobs { application.publish(:commented, job_application_id: application.id, author_id: users(:admin).id, body: "Hi") }

    expect(application).to have_received(:broadcast_refresh)
  end
end
