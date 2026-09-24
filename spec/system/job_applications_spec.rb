# frozen_string_literal: true

require "system_helper"

RSpec.describe "Job applications" do
  fixtures :all

  it "takes an applicant from application to hire, live in both windows" do
    using_session(:hr) do
      login :admin
      visit job_applications_path
      wait_for_live_updates
    end

    using_session(:applicant) do
      visit new_job_application_path
      select "Developer", from: "Job role"
      select "Senior", from: "Job level"
      fill_in "Given name", with: "Alex"
      fill_in "Family name", with: "Chen"
      fill_in "Email", with: "alex@example.com"
      fill_in "Github", with: "alexchen"
      fill_in "Link to your website", with: "https://alexchen.dev"
      fill_in "When do you like to start?", with: "2027-01-04"
      fill_in "Let us know about your interest in working with us", with: "I build calm software."
      attach_file "Attachments", Rails.root.join("spec/fixtures/files/cv.txt").to_s
      screenshot "job application form"
      click_on "Send application"

      expect(page).to have_content("Thank you for applying, Alex!")
      expect(page).to have_link("cv.txt")
      expect(page).not_to have_content("Updates")
      wait_for_live_updates
      screenshot "job application submitted"
    end
    application = JobApplication.find_by!(email: "alex@example.com")
    run_jobs

    using_session(:hr) do
      expect(page).to have_content("Alex Chen")
      screenshot "job applications list"
      click_on "Alex Chen"
      expect(page).to have_content("Application submitted")
      wait_for_live_updates

      fill_in "Comment", with: "Strong motivation letter."
      click_on "Submit"
      expect(page).to have_field("Comment", with: "")
    end
    run_jobs

    using_session(:hr) do
      expect(page).to have_content("Strong motivation letter.")
      screenshot "job application review"
      click_on "Invite for interview"
      within(".modal__frame") do
        expect(page).to have_css(".pill--active", text: "First interview")
        expect(page).to have_field("Calendly link", with: "https://calendly.com/nerdgeschoss/first-interview")
      end
      screenshot "job application interview invite"
      within(".modal__frame") { click_on "Send message" }
      expect(page).to have_content("You're invited to interview, Alex!")
    end
    run_jobs
    expect(last_mail!.subject).to eq "Your interview at nerdgeschoss"

    using_session(:applicant) do
      expect(page).to have_content("You're invited to interview, Alex!")
      expect(page).to have_css(".calendly-widget")
      expect(page).not_to have_button("Reject")
      screenshot "job application interview scheduling"
      report_calendly_booking
      expect(page).to have_content("Your interview is booked.")
      screenshot "job application interview booked"
    end
    run_jobs

    using_session(:hr) do
      expect(page).to have_content("Applicant: Interview booked")
      click_on "Invite for Craft Interview"
      within(".modal__frame") do
        click_on "Tech Interview with Jens"
        expect(page).to have_field("Calendly link", with: "https://calendly.com/jensravens/tech-interview")
        click_on "Send message"
      end
      expect(page).to have_content("Nice work, Alex! You're moving forward!")
    end
    run_jobs

    using_session(:applicant) do
      expect(page).to have_content("Nice work, Alex! You're moving forward!")
      report_calendly_booking
      expect(page).to have_content("Your interview is booked.")
    end
    run_jobs

    using_session(:hr) do
      expect(page).to have_content("Applicant: Craft interview booked")
      click_on "Hire applicant"
      within(".modal__frame") do
        expect(page).to have_select("Adapted level", selected: "Senior")
        select "Principal", from: "Adapted level"
      end
      screenshot "job application offer"
      within(".modal__frame") { click_on "Send message" }
      expect(page).to have_content("Congratulations, Alex! We'd love to have you!")
    end
    run_jobs
    expect(last_mail!.subject).to eq "Your offer from nerdgeschoss"

    using_session(:applicant) do
      expect(page).to have_content("offer you the Principal Developer role")
      screenshot "job application offer received"
    end

    using_session(:hr) do
      accept_confirm { click_on "Mark as hired" }
      expect(page).to have_content("Welcome to nerdgeschoss, Alex!")
      expect(page).to have_content("Offer sent")
      visit job_applications_path(filter: "joined")
      expect(page).to have_content("Alex Chen")
    end
    expect(application.reload.user).to have_attributes(email: "alex@example.com", roles: ["sprinter"], hired_on: Date.new(2027, 1, 4))
    run_jobs

    using_session(:applicant) do
      expect(page).to have_content("Welcome to nerdgeschoss, Alex!")
      screenshot "job application hired"
    end
  end

  private

  # A broadcast sent before the page has subscribed would be lost.
  def wait_for_live_updates
    expect(page).to have_css("turbo-cable-stream-source[connected]", visible: :all)
  end

  # The real widget can't be booked from a test, so send the message Calendly posts once someone has booked.
  def report_calendly_booking
    page.execute_script(<<~JS)
      window.dispatchEvent(new MessageEvent("message", {origin: "https://calendly.com", data: {event: "calendly.event_scheduled"}}))
    JS
  end
end
