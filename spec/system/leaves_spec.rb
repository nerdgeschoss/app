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
      find("input", class: "cur-year").send_keys "2", "0", "2", "2"
      find("span", text: "18").click
      find("span", text: "21").click
      fill_in "Title", with: "My Holiday"
      screenshot "request leave"
      click_on "Request leave"
    end
    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "John / My Holiday"
    expect(page).to have_content "pending approval"
    expect(page).not_to have_content "👍" # only admins can approve
    screenshot "user leaves"

    slack_message = Slack.instance.last_message
    expect(slack_message.channel).to eq Config.slack_hr_channel_id
    expect(slack_message.text).to include "<@slack-john>" # user is referenced within message
    expect(slack_message.text).to include "February 18 — 21, 2022" # date of leave is referenced within message
    url = URI.extract(slack_message.text).first
    expect(url).to include leaves_path # there's a link to this leave
    expect(url).not_to include ":3000" # tests run on a different port, this makes sure that the url helpers are set up correctly
  end

  it "approves a requested leave" do
    users(:john).leaves.create! title: "Holiday", type: :paid, days: ["2025-01-01"]
    login :admin
    visit leaves_path
    expect(page).to have_content "John / Holiday"
    expect(page).to have_content "pending approval"
    screenshot "leave approval"
    click_on "👍", match: :first
    message = Slack.instance.last_message
    expect(message.channel).to eq "slack-john"
    expect(message.text).to include "approved"
  end

  it "automatically approves a single day sick leave and changes the slack status" do
    login :john
    visit leaves_path
    click_on "Request leave"
    within ".modal" do
      select(Time.zone.today.strftime("%B"))
      find("span[aria-current=date]").click
      fill_in "Title", with: "Fever"
      select("sick")
      screenshot "request sick leave"
      click_on "Request leave"
    end
    expect(page).to have_content "John / Fever"
    expect(page).to have_content "approved"
    screenshot "sick leave approval"
    status = Slack.instance.last_slack_status_update
    expect(status.text).to eq "On sick leave"
    expect(status.slack_id).to eq "slack-john"
    expect(status.until_time).to eq Time.zone.today.end_of_day
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
