# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Job applications" do
  fixtures :all

  it "shows the application form to anonymous visitors" do
    get "/en/job_applications/new"
    expect(response).to have_http_status :ok
  end

  it "keeps the list to hr" do
    get "/en/job_applications"
    expect(response).to redirect_to "/en/login"
  end
end
