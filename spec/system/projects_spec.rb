# frozen_string_literal: true

require "system_helper"

RSpec.describe "Projects" do
  fixtures :all
  let(:project) { projects(:customer_project) }

  it "shows current projects" do
    login :admin
    visit projects_path
    expect(page).to have_content(project.name)
  end
end
