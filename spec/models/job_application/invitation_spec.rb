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

  it "moves an interviewed application to the craft interview" do
    application = job_applications(:jane_awaiting_interview)
    invitation = described_class.new(job_application: application, scheduling_url: "https://calendly.com/y", message: "Hey Jane")
    expect(invitation.stage).to eq "craft_interview"

    perform_enqueued_jobs { expect(invitation.save).to be true }

    expect(application.reload).to be_craft_interview
    expect(application.craft_interview_scheduling_url).to eq "https://calendly.com/y"
    expect(application.events.sole).to have_attributes(name: "craft_interview_invited")
    expect(last_mail!.subject).to eq "Your craft interview at nerdgeschoss"
  end
end
