# frozen_string_literal: true

require "system_helper"

RSpec.describe "Job applications" do
  fixtures :all

  it "lists applications and filters them with the pills" do
    login :admin
    visit job_applications_path
    expect(page).to have_content("Max Mustermann")
    expect(page).to have_content("Senior Developer")
    expect(page).to have_css(".pill--active", text: "new")
    expect(page).not_to have_content("Michelle Smith")
    click_on "rejected"
    expect(page).to have_current_path(job_applications_path(filter: "rejected"))
    expect(page).to have_content("Michelle Smith")
    expect(page).not_to have_content("Max Mustermann")
  end
end
