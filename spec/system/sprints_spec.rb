# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sprints" do
  fixtures :all

  it "creates a new sprint" do
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
end
