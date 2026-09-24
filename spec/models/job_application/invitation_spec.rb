# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Invitation do
  fixtures :all

  let(:application) { job_applications(:max_review) }
  let(:invitation) { described_class.new(job_application: application, scheduling_url: "https://calendly.com/x", message: "Hey Max") }

  it "needs a link and a message" do
    expect(described_class.new(job_application: application)).not_to be_valid
    expect(described_class.new(job_application: application, scheduling_url: "https://calendly.com/x")).not_to be_valid
  end

  it "moves the application to the interview and mails the message" do
    perform_enqueued_jobs { expect(invitation.save).to be true }

    expect(application.reload).to be_interview
    expect(application.interview_scheduling_url).to eq "https://calendly.com/x"
    expect(application.events.sole).to have_attributes(name: "interview_invited")
    expect(last_mail!.to.to_s).to eq "max@example.com"
    expect(last_mail!.subject).to eq "Your interview at nerdgeschoss"
    expect(last_mail!.body.text).to eq "Hey Max"
  end
end
