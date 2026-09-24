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

    it "records the booking once Calendly reports it" do
      application = job_applications(:jane_awaiting_interview)
      visit job_application_path(application)
      expect(page).to have_css(".calendly-widget")

      page.execute_script(<<~JS)
        window.dispatchEvent(new MessageEvent("message", {origin: "https://calendly.com", data: {event: "calendly.event_scheduled"}}))
      JS

      expect(page).to have_content("Your interview is booked.")
      expect(application.reload.interview_booked_at).to be_present
    end

    it "shows a booked interview and lets the applicant book again" do
      application = job_applications(:tim_booked_interview)
      visit job_application_path(application)
      expect(page).to have_content("Your interview is booked.")
      expect(page).not_to have_css(".calendly-widget")

      click_on "Update"
      expect(page).to have_css(".calendly-widget")
      expect(page).to have_content("You're invited to interview, Tim!")
      expect(application.reload.interview_booked_at).to be_nil
    end

    it "tells a rejected applicant" do
      visit job_application_path(job_applications(:michelle_rejected))
      expect(page).to have_content("Application Declined")
    end
  end

  describe "reviewing an application" do
    let(:application) { job_applications(:max_review) }

    it "invites the applicant with a preset" do
      login :admin
      visit job_application_path(application)
      click_on "Invite for interview"
      within ".modal__frame" do
        expect(page).to have_css(".pill--active", text: "First interview")
        expect(page).to have_field("Calendly link", with: "https://calendly.com/nerdgeschoss/first-interview")
        click_on "Tech Interview with Jens"
        expect(page).to have_field("Calendly link", with: "https://calendly.com/jensravens/tech-interview")
        click_on "Send message"
      end

      expect(page).to have_content("You're invited to interview, Max!")
      expect(page).not_to have_css(".modal--open")
      expect(application.reload.interview_scheduling_url).to eq "https://calendly.com/jensravens/tech-interview"
      run_jobs
      expect(last_mail!.to.to_s).to include "max@example.com"
      expect(last_mail!.body.text).to include "schedule a tech interview with Jens"
    end

    it "rejects the applicant with the prefilled message" do
      login :admin
      visit job_application_path(application)
      click_on "Reject"
      within ".modal__frame" do
        expect(page).to have_field("Message", with: /We appreciated the chance/)
        click_on "Send message"
      end

      expect(page).to have_content("Application Declined")
      expect(application.reload).to be_rejected
    end

    it "keeps the modal open when the message is missing" do
      login :admin
      visit job_application_path(application)
      click_on "Reject"
      within ".modal__frame" do
        fill_in "Message", with: ""
        click_on "Send message"
        expect(page).to have_content("Message can't be blank")
      end

      expect(page).to have_content("Thank you for applying, Max!")
      expect(application.reload).to be_review
    end

    it "invites an interviewed applicant to the craft interview" do
      application = job_applications(:jane_awaiting_interview)
      login :admin
      visit job_application_path(application)
      click_on "Invite for Craft Interview"
      within ".modal__frame" do
        expect(page).to have_content("Invite for Craft Interview")
        click_on "Tech Interview with Jens"
        expect(page).to have_field("Calendly link", with: "https://calendly.com/jensravens/tech-interview")
        click_on "Send message"
      end

      expect(page).to have_content("Nice work, Jane! You're moving forward!")
      expect(page).to have_css(".calendly-widget")
      expect(application.reload.craft_interview_scheduling_url).to eq "https://calendly.com/jensravens/tech-interview"
    end

    it "rejects an interviewed applicant with the interview text" do
      login :admin
      visit job_application_path(job_applications(:jane_awaiting_interview))
      click_on "Reject"
      within ".modal__frame" do
        expect(page).to have_field("Message", with: /second interview stage/)
        click_on "Send message"
      end

      expect(page).to have_content("Application Declined")
    end

    it "offers the job after the craft interview" do
      application = job_applications(:jane_awaiting_interview)
      application.update!(status: :craft_interview, craft_interview_scheduling_url: "https://calendly.com/jensravens/tech-interview")
      login :admin
      visit job_application_path(application)
      click_on "Hire applicant"
      within ".modal__frame" do
        expect(page).to have_select("Adapted level", selected: "Junior")
        expect(page).to have_field("Message", with: /Junior Developer at nerdgeschoss/)
        select "Senior", from: "Adapted level"
        click_on "Send message"
      end

      expect(page).to have_content("Congratulations, Jane! We'd love to have you!")
      expect(page).to have_content("offer you the Senior Developer role")
      expect(application.reload.offered_level).to eq "senior"
    end

    it "rejects after the craft interview with the craft text" do
      application = job_applications(:jane_awaiting_interview)
      application.update!(status: :craft_interview, craft_interview_scheduling_url: "https://calendly.com/jensravens/tech-interview")
      login :admin
      visit job_application_path(application)
      click_on "Reject"
      within ".modal__frame" do
        expect(page).to have_field("Message", with: /craft interview for the Junior Developer position/)
        click_on "Send message"
      end

      expect(page).to have_content("Application Declined")
    end

    it "hides the actions from everyone but hr" do
      visit job_application_path(application)
      expect(page).to have_content("Thank you for applying, Max!")
      expect(page).not_to have_button("Reject")

      login :john
      visit job_application_path(application)
      expect(page).to have_content("Thank you for applying, Max!")
      expect(page).not_to have_button("Reject")
      expect(page).not_to have_button("Invite for interview")
    end
  end
end
