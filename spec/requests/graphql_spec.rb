# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL" do
  fixtures :all
  let(:user) { users(:john) }
  let(:query) do
    <<-GRAPHQL
      {
        viewer {
          email
        }
      }
    GRAPHQL
  end

  it "shows login status" do
    post "/graphql", params: {query:}
    expect(response).to have_http_status :ok
    expect(json.data.viewer).to be_nil
  end

  it "returns data for logged in users" do
    post "/graphql", params: {query:}, headers: {"Authorization" => "Bearer #{user.api_token}"}
    expect(response).to have_http_status :ok
    expect(json.data.viewer.email).to eq "john@example.com"
  end
end
