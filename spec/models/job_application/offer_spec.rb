# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Offer do
  fixtures :all

  let(:application) { job_applications(:jane_awaiting_interview).tap { it.update!(status: :craft_interview) } }

  it "needs a known level and a message" do
    expect(described_class.new(job_application: application, offered_level: "senior")).not_to be_valid
    expect(described_class.new(job_application: application, offered_level: "boss", message: "Hi")).not_to be_valid
  end

  it "offers the adapted level and mails the message" do
    offer = described_class.new(job_application: application, offered_level: "senior", message: "Welcome aboard")
    perform_enqueued_jobs { expect(offer.save).to be true }

    expect(application.reload).to be_job_offer
    expect(application.offered_level).to eq "senior"
    expect(application.events.sole).to have_attributes(name: "offered")
    expect(last_mail!.subject).to eq "Your offer from nerdgeschoss"
    expect(last_mail!.body.text).to eq "Welcome aboard"
  end
end
