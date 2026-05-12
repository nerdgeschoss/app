# frozen_string_literal: true

require "system_helper"

RSpec.describe "Profits" do
  fixtures :all

  before { travel_to "2026-05-12" }

  it "shows the profit grid to HR with a total row per month" do
    login :admin
    visit "/"
    expect(page).to have_link("Profit")
    click_on "Profit"
    expect(page).to have_current_path("/profit")
    expect(page).to have_content("Profit")
    expect(page).to have_content("January 2026")
    expect(page).to have_content("Total")
  end

  it "offers year filter pills for the last 5 years and switches the range" do
    login :admin
    visit "/profit"
    %w[2022 2023 2024 2025 2026].each do |year|
      expect(page).to have_link(year)
    end
    click_on "2025"
    expect(page).to have_current_path("/profit?year=2025")
    expect(page).to have_content("December 2025")
  end

  it "hides the Profit sidebar entry from non-HR users" do
    login :john
    visit "/"
    expect(page).not_to have_link("Profit")
  end
end
