# frozen_string_literal: true

require "rails_helper"

RSpec.describe Slack do
  let(:slack) { Slack.instance }

  before do
    slack.debug = false
  end

  it "retrieves a slack id by email" do
    stub_request(:get, "https://slack.com/api/users.lookupByEmail?email=jon@nerdgeschoss.de")
      .to_return(status: 200, body: {user: {id: "15"}}.to_json, headers: {"Content-Type": "application/json"})
    stub_request(:get, "https://slack.com/api/users.lookupByEmail?email=someone@nerdgeschoss.de")
      .to_return(status: 200, body: {error: "not_found"}.to_json, headers: {"Content-Type": "application/json"})
    expect(slack.retrieve_users_slack_id_by_email("jon@nerdgeschoss.de")).to eq "15"
    expect(slack.retrieve_users_slack_id_by_email("someone@nerdgeschoss.de")).to eq nil
  end

  it "sends a message to a channel" do
    stub = stub_request(:post, "https://slack.com/api/chat.postMessage")
      .with(body: {channel: "test-channel", text: "hello world"}.to_json)
      .to_return(status: 200)
    slack.notify(channel: "test-channel", text: "hello world")
    expect(stub).to have_been_requested
  end
end