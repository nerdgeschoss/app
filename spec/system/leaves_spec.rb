# frozen_string_literal: true

require "system_helper"

RSpec.describe "Leaves" do
  fixtures :all

  let(:user) { users(:john) }

  it "requests a leave and notifies hr" do
    travel_to "2022-02-02"
    login user
    visit user_leaves_path(user)
    click_on "Request leave"
    within ".modal" do
      select("February")
      expect(page).to have_selector ".cur-year"
      find("input", class: "cur-year").set ""
      find("input", class: "cur-year").send_keys "2", "0", "2", "2"
      find("span", text: "18").click
      find("span", text: "21").click
      fill_in "Title", with: "My Holiday"
      screenshot "request leave"
      click_on "Request"
    end
    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "My Holiday"
    expect(page).to have_content "Pending"
    expect(page).not_to have_content "👍" # only admins can approve
    screenshot "user leaves"
  end

  it "approves a requested leave" do
    leave = users(:john).leaves.create! title: "Holiday", type: :paid, days: ["2025-01-01"]
    login :admin
    visit user_leaves_path(user)
    expect(page).to have_content "Holiday"
    expect(page).to have_content "Pending"
    screenshot "leave approval"
    within "#leave_#{leave.id}" do
      click_on "👍"
      expect(page).not_to have_content "👍"
    end
    message = last_slack_message
    expect(message.channel).to eq "slack-john"
    expect(message.text).to include "approved"
  end

  it "automatically approves a single day sick leave and changes the slack status" do
    login user
    date = Date.new(2025, 10, 22)
    travel_to date
    visit user_leaves_path(user)
    click_on "Request leave"
    within ".modal" do
      select(Time.zone.today.strftime("%B"))
      find(".flatpickr-day", text: date.day).click
      fill_in "Title", with: "Fever"
      select("Sick")
      screenshot "request sick leave"
      click_on "Request"
    end
    expect(page).to have_content "Fever"
    within(find(".card", text: "Fever")) { expect(page).not_to have_css(".status-pill") }
    screenshot "sick leave approval"
  end

  it "shows a warning if one of the leave days is in the past" do
    login user
    visit user_leaves_path(user)
    click_on "Request leave"

    expect(page).not_to have_content "Heads up: Some of the selected days are in the past."

    within ".modal" do
      find(".flatpickr-day.today").click

      expect(page).not_to have_content "Heads up: Some of the selected days are in the past."

      find(".flatpickr-prev-month").click
      first(".dayContainer .flatpickr-day").click
    end

    expect(page).to have_content "Heads up: Some of the selected days are in the past."
  end

  it "filters leaves by month" do
    date_range = Date.new(2025, 2, 1)..Date.new(2025, 2, 2)
    user.leaves.create(leave_during: date_range, days: date_range.to_a, title: "February Leave")

    travel_to "2025-01-01"

    login user
    visit user_leaves_path(user)
    expect(page).to have_content "Vacation!"
    expect(page).to have_content "February Leave"

    visit user_leaves_path(user, year: 2025, month: 1)
    expect(page).to have_content "Vacation!"
    expect(page).not_to have_content "February Leave"
  end

  it "shows another user's leaves to HR with the overview button and the summary" do
    travel_to "2025-01-01"
    login :admin
    visit user_leaves_path(user, year: 2025)
    expect(page).to have_content "John's Leaves"
    expect(page).to have_button "Overview"
    expect(page).to have_button "Request leave"
    ["All", "Pending", "Approved", "Rejected"].each { |label| expect(page).to have_link label }
    expect(page).to have_content(/🏖 Vacation\s+4 days/)
    expect(page).to have_content(/🤒 Sick leaves\s+1 day\b/)
    expect(page).to have_content(/🧳 Non-working\s+3 days/)
    expect(page).to have_css(".card--highlight-warning", count: 1)
    expect(page).to have_css(".status-pill--pending", text: "Pending")
    # the remaining days only show for the browser's current year
    expect(page).not_to have_content "Remaining for"
  end

  it "shows the own leaves page without the overview button" do
    login user
    visit user_leaves_path(user, year: 2025)
    expect(page).to have_content "Leaves"
    expect(page).to have_css(".text--h1-bold", exact_text: "Leaves")
    expect(page).to have_button "Request leave"
    expect(page).not_to have_button "Overview"
    expect(page).not_to have_content "John's Leaves"
  end

  it "keeps the tab when the month and year filters change" do
    travel_to "2025-01-01"
    login :admin
    visit user_leaves_path(user, year: 2025, status: "pending_approval")
    all("select")[0].select("January")
    expect(page).to have_current_path("/users/#{user.id}/leaves?status=pending_approval&year=2025&month=1")
    expect(page).to have_css(".pill--active", text: "Pending")
    expect(page).to have_content "Vacation Pending!"
    expect(page).not_to have_content "Sick leaves" # the summary cards only show on All

    all("select")[1].select("2024")
    expect(page).to have_current_path("/users/#{user.id}/leaves?status=pending_approval&year=2024&month=1")

    all("select")[0].select("All Months")
    expect(page).to have_current_path("/users/#{user.id}/leaves?status=pending_approval&year=2024")
  end

  it "edits a leave" do
    travel_to "2025-01-01"
    login :admin
    leave = leaves(:john_vacation)
    visit user_leaves_path(user, year: 2025)
    within("#leave_#{leave.id}") { click_on "✏️" }
    within ".modal" do
      expect(page).to have_field("Title", with: "Vacation!")
      expect(page).to have_content "Saving sends this leave back to pending approval."
      fill_in "Title", with: "Vacation edited"
      click_on "Save"
    end
    expect(page).not_to have_css ".modal"
    expect(page).to have_content "Vacation edited"
    leave.reload
    expect(leave.title).to eq "Vacation edited"
    expect(leave).to be_approved # only a change of days or type sends it back
  end

  it "outlines a rejected leave" do
    user.leaves.create!(title: "Rejected trip", type: :paid, status: :rejected, days: ["2025-03-03"])
    login user
    visit user_leaves_path(user, year: 2025, status: "rejected")
    expect(page).to have_css(".card--highlight-danger", count: 1)
    expect(page).to have_css(".status-pill--rejected", text: "Rejected")
    expect(page).to have_content "Rejected trip"
    expect(page).not_to have_content "Vacation!"
  end

  it "highlights the leaves section in the sidebar" do
    admin = users(:admin)
    login admin
    [user_leaves_path(user), leaves_overview_path].each do |path|
      visit path
      expect(page).to have_css("a[href='/users/#{admin.id}/leaves'] .sidebar__link--active")
      expect(page).not_to have_css("a[href='/users'] .sidebar__link--active")
    end
  end

  describe "HR Overview" do
    it "shows day counts of the different leave types for the given month" do
      travel_to "2025-01-01"

      login :admin
      visit leaves_overview_path

      expect(page).to have_content "🏖 4"
      expect(page).to have_content "🤒 1"
      expect(page).to have_content "🧳 3"

      visit leaves_overview_path(year: 2024, month: 12)
      expect(page).to have_content "🏖 2"
      expect(page).to have_content "🤒 0"
      expect(page).to have_content "🧳 0"
    end

    it "shows pending leaves" do
      travel_to "2025-01-01"

      login :admin
      visit leaves_overview_path

      within "#pending_requests" do
        expect(page).to have_content "John"
        expect(page).to have_button "👍"
      end
    end

    it "is not available to regular users" do
      login user
      visit leaves_overview_path
      # Capybara keeps the server error of the last request and raises it on the next visit or at teardown
      expect { page.raise_server_error! }.to raise_error(Pundit::NotAuthorizedError)
      expect(page).not_to have_content "Pending Requests"
    end

    it "rejects a pending leave from the overview" do
      travel_to "2025-01-01"
      login :admin
      visit leaves_overview_path
      within("#pending_requests") { click_on "👎" }
      expect(page).to have_css "#pending_requests", text: "No leave requests are waiting for your approval."
      expect(leaves(:john_vacation_pending).reload).to be_rejected
    end

    it "paints the leaves of the month and clips a leave that continues" do
      travel_to "2025-01-01"
      login :admin
      visit leaves_overview_path
      expect(page).to have_content "Jan 2025"
      expect(page).to have_css(".leave-calendar__day--non-working", count: 9)
      expect(page).to have_css(".leave-calendar__segment--start", count: 5)
      expect(page).to have_css(".leave-calendar__segment--continues-before", count: 1)
      expect(page).not_to have_css(".leave-calendar__segment--continues-after")
      # the browser serializes the inline grid placement as grid-area, so read the column from the style
      expect(find(".leave-calendar__segment--continues-before").evaluate_script("this.style.gridColumn")).to eq "1"
      not_working = all(".leave-calendar__segment[data-leave-id='#{leaves(:john_not_working).id}']")
      expect(not_working.map { |segment| segment.evaluate_script("this.style.gridColumn") }).to eq ["7", "8", "9"]

      visit leaves_overview_path(year: 2024, month: 12)
      expect(page).to have_content "Dec 2024"
      expect(page).to have_css(".leave-calendar__segment--start", count: 1)
      expect(find(".leave-calendar__segment--start").evaluate_script("this.style.gridColumn")).to eq "30"
      expect(page).to have_css(".leave-calendar__segment--continues-after", count: 1)
      continues_after = find(".leave-calendar__segment--continues-after")
      expect(continues_after.evaluate_script("this.style.gridColumn")).to eq "31"
      expect(continues_after["data-day"]).to eq "2024-12-31"
      expect(page).to have_css(".leave-calendar__user", text: "🏖 2")
    end

    it "shows a tooltip on click" do
      travel_to "2025-01-01"
      login :admin
      visit leaves_overview_path
      bar = find(".leave-calendar__segment--continues-before")
      bar.click
      within ".leave-calendar__tooltip" do
        expect(page).to have_content "John: Vacation"
        expect(page).to have_content "30 Dec to 2 Jan"
        expect(page).to have_content "Approved"
        expect(page).to have_button "✏️"
      end
      find(".text--h1-bold", text: "Leaves Overview").click
      expect(page).not_to have_css ".leave-calendar__tooltip"

      bar.click
      expect(page).to have_css ".leave-calendar__tooltip"
      bar.click
      expect(page).not_to have_css ".leave-calendar__tooltip"
    end

    it "navigates between months and to the employee page" do
      travel_to "2025-01-01"
      login :admin
      visit leaves_overview_path
      find(".leave-calendar__arrow--previous").click
      expect(page).to have_current_path("/leaves_overview?year=2024&month=12")
      expect(page).to have_content "Dec 2024"
      find(".leave-calendar__arrow--next").click
      expect(page).to have_current_path("/leaves_overview?year=2025&month=1")
      find(".leave-calendar__user", text: "🏖 4").click
      expect(page).to have_current_path("/users/#{user.id}/leaves?year=2025&month=1")
      expect(page).to have_content "John's Leaves"
    end
  end

  describe "Team Overview" do
    it "shows the leaves for a team" do
      travel_to "2025-01-01"

      john = users(:john)
      john.update!(roles: ["team-code-cowboys"])
      john.leaves.delete_all

      john.leaves.create!(type: :sick, title: "Private Sickness", days: ["2024-12-30"])
      john.leaves.create!(type: :sick, title: "Private Sickness", days: ["2025-01-01", "2025-01-02"])

      cigdem = users(:cigdem)
      cigdem.update!(roles: ["team-backlog-busters"])
      cigdem.leaves.create!(type: :non_working, title: "Not Working", days: ["2025-01-01"])

      yuki = users(:yuki)
      yuki.update!(roles: ["team-code-cowboys"])
      yuki.leaves.create!(type: :paid, title: "Holiday in the Alps", days: ["2025-01-03"])

      team_hash = Rails.application.message_verifier(:team_name).generate("code-cowboys")
      visit team_overview_leaves_path(team_hash:)

      within "table tr:nth-child(2)" do
        expect(page).to have_content "John Doe"
        expect(page).to have_content "01.01.25, 02.01.25"
        expect(page).to have_content "On sick leave"
        expect(page).not_to have_content "Private Sickness"
      end

      expect(page).not_to have_content "Cigdem"

      within "table tr:nth-child(3)" do
        expect(page).to have_content "Yuki Doe"
        expect(page).to have_content "03.01.25"
        expect(page).to have_content "On vacation"
        expect(page).not_to have_content "Holiday in the Alps"
      end
    end
  end
end
