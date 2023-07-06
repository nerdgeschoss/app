# frozen_string_literal: true

require "rails_helper"

RSpec.describe Github do
  describe "#project_items" do
    it "returns project items" do
      body = <<~JSON
        {
          "data": {

            "organization": {
              "project": {
                "items": {
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor": "MTAw"
                  },
                  "nodes": [
                    {
                      "type": "ISSUE",
                      "content": {
                        "number": 157,
                        "repository": {
                          "name": "laic",
                          "owner": {
                            "login": "nerdgeschoss"
                          }
                        },
                        "assignees": {
                          "nodes": [
                            {
                              "email": "john@example.com"
                            }
                          ]
                        }
                      },
                      "name": {
                        "text": "APP-777 - Implement Banner and QR Code"
                      },
                      "status": {
                        "name": "Done"
                      },
                      "sprint": {
                        "title": "S2023-13"
                      },
                      "points": {
                        "number": 3
                      },
                      "id": "I_kwDOHqBmEs5py4Jr"
                    }
                  ]
                }
              }
            }
          }
        }
      JSON

      stub_request(:post, "https://api.github.com/graphql").to_return(status: 200, body:)

      project_item = Github.new.project_items.first

      expect(project_item.id).to eq "I_kwDOHqBmEs5py4Jr"
      expect(project_item.title).to eq "APP-777 - Implement Banner and QR Code"
      expect(project_item.assignee_emails).to match_array ["john@example.com"]
      expect(project_item.repository).to eq "nerdgeschoss/laic"
      expect(project_item.issue_number).to eq 157
      expect(project_item.sprint_title).to eq "S2023-13"
      expect(project_item.status).to eq "Done"
      expect(project_item.points).to eq 3
    end
  end
end
