# frozen_string_literal: true

require "system_helper"

RSpec.describe "Styleguide" do
  fixtures :all

  it "renders the styleguide page" do
    login :admin
    visit styleguide_path
    expect(page).to have_content("Component Styleguide")
    expect(page).to have_content("Text")
    expect(page).to have_content("Button")
    expect(page).to have_content("Avatar")
    expect(page).to have_content("Icon")
    expect(page).to have_content("Card")
    expect(page).to have_content("SprintCard")
    expect(page).to have_content("Performance")
    expect(page).to have_content("RetroList")
  end
end
