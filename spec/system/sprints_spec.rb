# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sprints" do
  fixtures :all

  context "creating a sprint" do
    it "needs the hr role to see the add button" do
      login :john
      visit sprints_path
      expect(page).to have_content "Sprints"
      expect(page).not_to have_content "add"
    end

    it "creates a new sprint" do
      travel_to "2022-02-02"
      login :admin
      visit sprints_path

      click_on "add"
      within ".modal" do
        fill_in "Title", with: "Test Sprint 1"
        fill_in "Sprint from", with: "2022-02-01"
        fill_in "Sprint until", with: "2022-02-14"
        fill_in "Working days", with: "10"
        screenshot "sprint creation"
        click_on "Save"
      end
      expect(page).not_to have_selector ".modal"
      expect(page).to have_content "Test Sprint 1"
      User.sprinter.each do |user|
        expect(page).to have_content user.display_name
      end
      expect(Sprint.find_by(title: "Test Sprint 1")).to have_attributes working_days: 10
    end
  end
end
