# frozen_string_literal: true

require "system_helper"

RSpec.describe "Leaves" do
  fixtures :all

  it "requests a leave and notifies hr" do
    travel_to "2023-02-02"
    login :john
    visit leaves_path
    click_on "Request leave"
    within ".modal" do
      find("span", text: "24").click
      find("span", text: "27").click
      fill_in "Title", with: "My Holiday"
      screenshot "request leave"
      click_on "Request leave"
    end
    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "John / My Holiday"
    expect(page).to have_content "Pending Approval"
    expect(page).not_to have_content "👍" # only admins can approve
    screenshot "user leaves"

    slack_message = Slack.instance.last_message
    expect(slack_message.channel).to eq Config.slack_hr_channel_id
    expect(slack_message.text).to include "<@slack-john>" # user is referenced within message
    expect(slack_message.text).to include "February 24 — 27, 2023" # date of leave is referenced within message
    url = URI.extract(slack_message.text).first
    expect(url).to include leaves_path # there's a link to this leave
  end

  it "approves a requested leave" do
    users(:john).leaves.create! title: "Holiday", type: :paid, days: ["2025-01-01"]
    login :admin
    visit leaves_path
    expect(page).to have_content "John / Holiday"
    expect(page).to have_content "Pending Approval"
    screenshot "leave approval"
    click_on "👍"
    expect(page).not_to have_content "Pending Approval"
  end
end
