# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sprint Feedback" do
  fixtures :all

  before do
    travel_to "2023-02-05"
    login :john
  end

  it "shows a reminder on the home page when the feedback for last sprint was not filled out" do
    visit root_path
    expect(page).to have_content "Missing Sprint Feedback"
  end

  it "shows the feedback form on the sprints page" do
    visit sprints_path
    expect(page).to have_content "Please write your feedback"

    fill_in "Retro text", with: "I'm happy"
    find("[title='5 / 5']").choose
    click_button
    expect(page).to have_content "John rated: 5"
    expect(page).to have_content "I'm happy"

    visit root_path
    expect(page).not_to have_content "Missing Sprint Feedback"
  end

  it "allows editing the retro feedback" do
    feedback = sprint_feedbacks(:sprint_feedback_john)
    feedback.update!(retro_text: "I'm happy!", retro_rating: 5)
    visit sprints_path

    click_button("Edit")
    fill_in "Retro text", with: "I'm okay-ish"
    find("[title='3 / 5']").choose
    click_button("Update")

    expect(page).to have_content "John rated: 3"
    expect(page).to have_content "I'm okay-ish"
  end

  it "allows skipping the retro" do
    visit sprints_path

    check("Skip retro")
    click_button("Update")

    expect(page).to have_content "John skipped"
  end
end
