# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sprints" do
  fixtures :all

  context "filling out feedback" do
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

      fill_in "sprint_feedback[retro_text]", with: "I'm happy"
      choose "5"
      click_button
      expect(page).to have_content "John rated: 5"
    end

    it "shows sprint feedback on the sprint card" do
      visit sprints_path
      expect(page).to have_content "Yuki rated: 5"
      expect(page).to have_content "I liked the sprint"
    end
  end
end
