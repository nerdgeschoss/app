# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  fixtures :all

  describe "emails" do
    it "lists email addresses of sprinters" do
      get "/api/v1/users/emails", params: {token: Config.api_emails_list_token}

      expect(response.parsed_body).to eq({
        "results" => [
          "cigdem@example.com",
          "john@example.com",
          "john-no-slack@example.com",
          "yuki@example.com",
          "zacharias@example.com"
        ]
      })
    end

    it "rejects unauthorized requests" do
      get "/api/v1/users/emails"

      expect(response).to have_http_status :unauthorized
    end
  end
end
