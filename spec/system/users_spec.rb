# frozen_string_literal: true

require "system_helper"

RSpec.describe "Users" do
  fixtures :all

  it "lists users and shows user profile" do
    login :admin
    visit users_path

    expect(page).to have_content "Users"
    expect(page).to have_content users(:admin).full_name

    first("a", text: users(:john).full_name).click
    expect(page).to have_content users(:john).full_name
    expect(page).to have_content "Remaining holidays"
    expect(page).to have_content "Salary history"
    expect(page).to have_content "Inventory"
  end

  it "filters users" do
    login :admin
    visit users_path(filter: "archive")

    expect(page).to have_content "Users"
  end
end
