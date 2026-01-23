# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do
  fixtures :all

  it "updates project dependencies" do
    project = projects(:customer_project)
    patch "/api/v1/projects/#{project.signed_id}", params: {framework_versions: {ruby: "3.2"}}
    expect(response).to have_http_status :no_content
    expect(project.reload.framework_versions).to eq({"ruby" => "3.2", "rails" => "7.0"})
  end

  it "rejects unauthorized updates" do
    patch "/api/v1/projects/some-id", params: {framework_versions: {ruby: "3.2"}}
    expect(response).to have_http_status :unauthorized
  end
end
