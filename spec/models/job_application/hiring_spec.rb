# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Hiring do
  fixtures :all

  let(:application) { job_applications(:max_review).tap { it.update!(status: :job_offer) } }

  it "creates the employee and closes the application" do
    user = perform_enqueued_jobs { application.hire! }

    expect(user).to have_attributes(email: "max@example.com", first_name: "Max", last_name: "Mustermann",
      github_handle: "max", hired_on: Date.new(2026, 12, 12), roles: ["sprinter"])
    expect(application.reload).to be_hired
    expect(application.user).to eq user
    expect(application.events.sole).to have_attributes(name: "hired", payload: include("user_id" => user.id))
  end

  it "starts today without a start date" do
    application.update!(available_from: nil)
    travel_to Date.new(2026, 10, 1) do
      expect(application.hire!.hired_on).to eq Date.new(2026, 10, 1)
    end
  end

  it "links an existing user instead of creating one" do
    john = users(:john)
    application.update!(email: "JOHN@example.com")

    expect { expect(application.hire!).to eq john }.not_to(change { User.count })
    expect(john.reload.roles).to eq ["sprinter"]
    expect(john.hired_on).to eq Date.new(2026, 12, 12)
  end

  it "brings a former employee back as a sprinter" do
    users(:john).update!(roles: [])
    application.update!(email: "john@example.com")

    expect(application.hire!.roles).to eq ["sprinter"]
  end
end
