# frozen_string_literal: true

require "system_helper"

RSpec.describe "Retrospectives" do
  fixtures :all
  let(:user) { users(:john) }
  let(:sprint) { Sprint.create!(title: "Sprint 1", sprint_from: 2.weeks.ago, sprint_until: 1.week.ago) }
  let(:feedback) { sprint.sprint_feedbacks.create!(user:) }

  before do
    travel_to "2018-02-05"
    login user
  end

  it "shows a reminder on the home page when the feedback for last sprint was not filled out" do
    feedback
    visit root_path
    expect(page).to have_content "Retrospective Notes Missing"

    feedback.update! retro_text: "I'm happy", retro_rating: 5
    visit root_path
    expect(page).not_to have_content "Retrospective Notes Missing"
  end

  it "shows the feedback form on the sprints page" do
    visit sprint_feedback_path(feedback)
    click_on "leave feedback"

    choose "retro-rating-4"
    fill_in "Text", with: "I'm happy"
    click_on "Save"

    expect(page).not_to have_selector ".modal"

    expect(page).to have_content "4/5"
    expect(page).to have_content "I'm happy"
  end

  it "allows skipping the retro" do
    visit sprint_feedback_path(feedback)
    click_on "leave feedback"

    check "Skip rating this sprint"
    click_on "Save"

    expect(page).to have_content "/5"
  end
end
