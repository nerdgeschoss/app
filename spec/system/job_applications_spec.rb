# frozen_string_literal: true

require "system_helper"

RSpec.describe "Job applications" do
  fixtures :all

  it "lists applications and filters them with the pills" do
    login :admin
    visit job_applications_path
    expect(page).to have_content("Max Mustermann")
    expect(page).to have_content("Senior Developer")
    expect(page).to have_css(".pill--active", text: "new")
    expect(page).not_to have_content("Michelle Smith")
    click_on "rejected"
    expect(page).to have_current_path(job_applications_path(filter: "rejected"))
    expect(page).to have_content("Michelle Smith")
    expect(page).not_to have_content("Max Mustermann")
  end

  it "lets anyone apply without an account" do
    visit new_job_application_path
    select "Designer", from: "Job role"
    select "Principal", from: "Job level"
    fill_in "Given name", with: "Alex"
    fill_in "Family name", with: "Chen"
    fill_in "Email", with: "alex@example.com"
    fill_in "Github", with: "alexchen"
    fill_in "Link to your website", with: "https://alexchen.dev"
    fill_in "When do you like to start?", with: "2027-01-04"
    fill_in "Let us know about your interest in working with us", with: "I build calm interfaces."
    attach_file "Attachments", Rails.root.join("spec/fixtures/files/cv.txt").to_s
    click_on "Send application"

    # Wait for the direct upload to finish and the form to re-submit before reading the record.
    expect(page).to have_content("Thank you for applying, Alex!")
    application = JobApplication.find_by!(email: "alex@example.com")
    expect(page).to have_current_path(job_application_path(application))
    expect(application.attachments.count).to eq 1
    expect(application.job_role).to eq "designer"
    expect(application.level).to eq "principal"
  end

  it "shows the errors instead of losing the application" do
    visit new_job_application_path
    click_on "Send application"

    expect(page).to have_content("Given name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_current_path(new_job_application_path)
  end

  describe "the status page" do
    it "shows the status and the submitted fields" do
      application = job_applications(:max_review)
      application.attachments.attach(io: File.open(Rails.root.join("spec/fixtures/files/cv.txt")), filename: "cv.txt")
      visit job_application_path(application)

      expect(page).to have_content("Thank you for applying, Max!")
      expect(page).to have_content("Application submitted")
      expect(page).to have_content("Mustermann")
      expect(page).to have_content("Developer")
      expect(page).to have_content("Senior")
      expect(page).to have_link("max", href: "https://github.com/max")
      expect(page).to have_link("cv.txt")
    end

    it "tells an invited applicant apart from one who has booked" do
      visit job_application_path(job_applications(:jane_awaiting_interview))
      expect(page).to have_content("You're invited to interview, Jane!")

      visit job_application_path(job_applications(:tim_booked_interview))
      expect(page).to have_content("You're all set, Tim!")
    end

    it "tells a rejected applicant" do
      visit job_application_path(job_applications(:michelle_rejected))
      expect(page).to have_content("Application Declined")
    end
  end
end
