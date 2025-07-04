# frozen_string_literal: true

require "system_helper"

RSpec.describe "Daily Nerd messages" do
  fixtures :all
  let(:user) { users(:john) }
  let(:sprint) { sprints(:empty) }
  let(:sprint_feedback) { SprintFeedback.find_by(user:, sprint:) }

  before do
    allow(Slack.instance).to receive(:retrieve_users_profile_image_url_by_email).and_return("https://example.com/image.jpg")
    allow(Slack.instance).to receive(:post_personalized_message_to_daily_nerd_channel)
  end

  it "creates and edits daily nerd messages" do
    travel_to "2023-01-29"
    login user

    visit root_path
    fill_in "Message", with: "I'm a daily nerd"
    click_on "Submit daily nerd"

    expect(page).to have_content "Update daily nerd"
  end

  it "does not show the form, when there is no current sprint" do
    travel_to "3000-01-01"
    login user

    visit root_path

    expect(page).not_to have_content "Daily Nerd"
  end

  it "updates an entry" do
    travel_to "2023-01-29"
    login user

    feedback = Sprint.current.sole.sprint_feedbacks.find_by(user_id: user.id)
    feedback.daily_nerd_messages.create!(message: "I'm a daily nerd")

    visit root_path
    fill_in "Message", with: "updated nerd"
    click_on "Update daily nerd message"
  end
end
