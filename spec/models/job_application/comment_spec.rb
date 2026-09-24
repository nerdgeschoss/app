# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Comment do
  fixtures :all

  let(:application) { job_applications(:max_review) }

  it "needs a body" do
    expect(described_class.new(job_application: application, author: users(:admin))).not_to be_valid
  end

  it "records the comment with its author" do
    comment = described_class.new(job_application: application, author: users(:admin), body: "Strong portfolio")
    perform_enqueued_jobs { expect(comment.save).to be true }

    expect(application.events.sole).to have_attributes(name: "commented",
      payload: include("author_id" => users(:admin).id, "body" => "Strong portfolio"))
  end
end
