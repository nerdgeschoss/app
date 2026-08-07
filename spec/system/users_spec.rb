# frozen_string_literal: true

require "system_helper"

RSpec.describe "Users" do
  fixtures :all
  let(:user) { users(:john) }

  it "lists users and filters them with the pills" do
    login :admin
    visit users_path
    expect(page).to have_content(user.first_name)
    expect(page).to have_css(".pill--active", text: "employee")
    click_on "hr"
    expect(page).to have_current_path(users_path(filter: "hr"))
    expect(page).to have_css(".pill--active", text: "hr")
    expect(page).not_to have_content(user.first_name)
  end
end
