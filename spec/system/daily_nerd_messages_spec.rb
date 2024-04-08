# frozen_string_literal: true

require "system_helper"

RSpec.describe "Daily Nerd messages" do
  fixtures :all
  let(:user) { users(:john) }
  let(:sprint) { sprints(:empty) }
  let(:sprint_feedback) { SprintFeedback.find_by(user:, sprint:) }

  before do
    allow(Slack.instance).to receive(:retrieve_users_profile_image_url_by_email).and_return("https://example.com/image.jpg")
    allow(Slack.instance).to receive(:push_personalized_message_to_daily_nerd_channel)
  end

  def login_and_create_daily_nerd_message
    travel_to "2023-01-29"
    login user

    visit root_path

    expect(page).to have_content "Daily Nerd"
    expect(page).to have_field "Message", placeholder: "How was your day? What did you learn?"

    fill_in "Message", with: "I'm a daily nerd"
    click_on "Create Daily nerd message"

    expect(page).to have_current_path sprints_path
    visit root_path

    expect(page).to have_field "Message", with: "I'm a daily nerd"

    fill_in "Message", with: "I'm a daily nerd and I learned a lot"
    click_on "Update Daily nerd message"
  end

  it "creates and edits daily nerd messages" do
    login_and_create_daily_nerd_message

    expect(page).to have_current_path sprints_path
    visit root_path

    expect(page).to have_field "Message", with: "I'm a daily nerd and I learned a lot"
  end

  it "does not show the form, when there is no current sprint" do
    travel_to "3000-01-01"
    login user

    visit root_path

    expect(page).not_to have_content "Daily Nerd"
    expect(page).not_to have_field "Message"
  end

  it "adds a daily nerd entry to the sprint feedback" do
    expect(sprint_feedback.daily_nerd_count).to eq 3

    login_and_create_daily_nerd_message

    expect(sprint_feedback.reload.daily_nerd_count).to eq 4
    expect(sprint_feedback.daily_nerd_entry_dates).to include(Time.zone.now)
  end
end
