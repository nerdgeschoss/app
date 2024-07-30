# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sprint Feedback" do
  fixtures :all

  context "filling out the retro" do
    before do
      travel_to "2023-02-02"
      login :john
    end

    it "shows a reminder on the home page when the feedback for last sprint was not filled out" do
      visit root_path
      expect(page).to have_content "REMINDER"
    end

    it "shows the feedback form on the sprints page when the feedback for last sprint was not filled out" do
      visit sprints_path
      expect(page).to have_content "Please write your feedback"

      fill_in "Retro text", with: "I'm happy"
      select "5", from: "Retro rating"
      click_button
      expect(page).to have_content "John rated: 5"
      expect(page).to have_content "I'm happy"

      visit root_path
      expect(page).not_to have_content "REMINDER"
    end
  end
end
