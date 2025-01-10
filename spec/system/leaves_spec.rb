# frozen_string_literal: true

require "system_helper"

RSpec.describe "Leaves" do
  fixtures :all

  it "requests a leave and notifies hr" do
    travel_to "2022-02-02"
    login :john
    visit leaves_path
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
      click_on "Request leave"
    end
    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "John / My Holiday"
    expect(page).to have_content "pending_approval"
    expect(page).not_to have_content "👍" # only admins can approve
    screenshot "user leaves"
  end

  it "approves a requested leave" do
    leave = users(:john).leaves.create! title: "Holiday", type: :paid, days: ["2025-01-01"]
    login :admin
    visit leaves_path
    expect(page).to have_content "John / Holiday"
    expect(page).to have_content "pending_approval"
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
    login :john
    date = Date.new(2025, 10, 22)
    travel_to date
    visit leaves_path
    click_on "Request leave"
    within ".modal" do
      select(Time.zone.today.strftime("%B"))
      find(".flatpickr-day", text: date.day).click
      fill_in "Title", with: "Fever"
      select("Sick")
      screenshot "request sick leave"
      click_on "Request leave"
    end
    expect(page).to have_content "John / Fever"
    expect(page).to have_content "approved"
    screenshot "sick leave approval"
  end

  it "shows a warning if one of the leave days is in the past" do
    login :john
    visit leaves_path
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
end
