# frozen_string_literal: true

require "system_helper"

RSpec.describe "Leaves" do
  fixtures :all
  let(:user) { users(:john) }

  it "creates and edits inventory" do
    travel_to "2022-02-02"
    login :admin
    visit user_path(user)
    click_on "add"
    within ".modal" do
      fill_in "Name", with: "MacBook Pro M3"
      screenshot "add_inventory"
      click_on "Save"
    end

    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "MacBook Pro M3"
    expect(page).to have_content "February 02, 2022"

    click_on "MacBook Pro M3"
    within ".modal" do
      fill_in "Returned at", with: DateTime.current
      click_on "Save"
    end

    expect(page).not_to have_selector ".modal"
    expect(page).to have_selector ".muted"

    click_on "MacBook Pro M3"
    click_on "Delete"

    expect(page).not_to have_content "MacBook Pro M3"
  end
end
