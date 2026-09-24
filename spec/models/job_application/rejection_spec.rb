# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Rejection do
  fixtures :all

  let(:application) { job_applications(:max_review) }

  it "needs a message" do
    expect(described_class.new(job_application: application)).not_to be_valid
  end

  it "rejects the application, remembering its stage, and mails the message" do
    perform_enqueued_jobs { expect(described_class.new(job_application: application, message: "Sorry").save).to be true }

    expect(application.reload).to be_rejected
    expect(application.events.sole).to have_attributes(name: "rejected", payload: include("from_status" => "review"))
    expect(last_mail!.body.text).to eq "Sorry"
  end
end
