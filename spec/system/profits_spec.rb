# frozen_string_literal: true

require "system_helper"

RSpec.describe "Profits" do
  fixtures :all

  before { travel_to "2026-05-12" }

  it "shows the profit grid to HR with a total row per month" do
    login :admin
    visit "/"
    expect(page).to have_link("Profits")
    click_on "Profits"
    expect(page).to have_current_path("/profits")
    expect(page).to have_content("Profits")
    expect(page).to have_content("January 2026")
    expect(page).to have_content("Total")
    expect(page).to have_content("By employee")
    expect(page).to have_content("By project")
  end

  it "offers year filter pills for the last 5 years and switches the range" do
    login :admin
    visit "/profits"
    ["2022", "2023", "2024", "2025", "2026"].each do |year|
      expect(page).to have_link(year)
    end
    click_on "2025"
    expect(page).to have_current_path("/profits?year=2025")
    expect(page).to have_content("December 2025")
  end

  it "hides the Profits sidebar entry from non-HR users" do
    login :john
    visit "/"
    expect(page).not_to have_link("Profits")
  end
end
