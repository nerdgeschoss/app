# frozen_string_literal: true

require "system_helper"

RSpec.describe "Sessions" do
  fixtures :all

  it "logs a user in via a code" do
    visit root_path
    expect(page).to have_content "Login"
    fill_in "Email", with: "admin@example.com"
    click_on "Login"
    expect(page).to have_content "Code"

    run_jobs
    expect(last_mail!.body).to have_content "Your login code is"
    code = last_mail.body.to_s.scan(/\d{6}/).first
    expect(code).to be_present
    fill_in "Code", with: code
    click_on "Login"
    expect(page).to have_content "Hello"
  end

  it "logs the user out" do
    login :john
    visit logout_path
    expect(page).to have_content "Login"
  end
end
