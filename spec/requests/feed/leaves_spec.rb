# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Leaves ICS Feed" do
  fixtures :all

  it "rejects requests not containing a secret" do
    get "/en/feed/leaves.ics"
    expect(response).to have_http_status :unauthorized
    expect(response.body).to be_empty
  end

  it "retrieves a list of leaves" do
    get "/en/feed/leaves.ics?auth=#{users(:admin).id}"
    expect(response).to have_http_status :ok
    expect(response.body).to include "John: Having the Flu"
    expect(response.body).to include "John: Vacation"
    expect(response.body).to include "(pending approval)"
  end
end
