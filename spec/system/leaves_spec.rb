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
    message = Slack.instance.last_message
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
    expect(page).to have_content "Approved"
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

  describe "HR Overview" do
    it "shows day counts of the different leave types for the given month" do
      travel_to "2025-01-01"

      login :admin
      visit leaves_hr_overview_path

      expect(page).to have_content "🏖 4"
      expect(page).to have_content "🤒 1"
      expect(page).to have_content "🧳 3"

      visit leaves_hr_overview_path(year: 2024, month: 12)
      expect(page).to have_content "🏖 2"
      expect(page).to have_content "🤒 0"
      expect(page).to have_content "🧳 0"
    end

    it "shows pending leaves" do
      travel_to "2025-01-01"

      login :admin
      visit leaves_hr_overview_path

      within "#pending_requests" do
        expect(page).to have_content "John"
        expect(page).to have_button "👍"
      end
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
