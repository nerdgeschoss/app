# frozen_string_literal: true

require "system_helper"

RSpec.describe "Payslips" do
  fixtures :all

  it "shows payslips for the logged in user" do
    login :admin
    visit payslips_path
    expect(page).to have_content "Payslips"
  end

  it "does not show the add button for non-hr users" do
    login :john
    visit payslips_path
    expect(page).not_to have_content "add"
  end

  it "creates a new payslip" do
    login :admin
    visit payslips_path
    click_on "add"
    within ".modal" do
      select "Admin", from: "User"
      fill_in "Month", with: "2024-03-01"
      attach_file "payslip_pdf", Rails.root.join("spec/fixtures/files/test.pdf")
      click_on "create"
    end
    expect(page).not_to have_selector ".modal"
    expect(page).to have_content "March 2024"
  end
end
