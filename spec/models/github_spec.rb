# frozen_string_literal: true

require "rails_helper"

RSpec.describe Github do
  around do |example|
    Config.stub(github_access_token: "TEST") do
      example.run
    end
  end

  describe "#sprint_board_items" do
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
                          "name": "some-project",
                          "owner": {
                            "login": "nerdgeschoss"
                          }
                        },
                        "assignees": {
                          "nodes": [
                            {
                              "login": "john"
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
                    },
                    {
                      "type": "DRAFT_ISSUE",
                      "name": {
                        "text": "APP-123 - Draft"
                      },
                      "status": {
                        "name": null
                      },
                      "sprint": {
                        "title": ""
                      },
                      "points": {
                        "number": null
                      },
                      "id": "I_123"
                    }
                  ]
                }
              }
            }
          }
        }
      JSON

      stub_request(:post, "https://api.github.com/graphql").to_return(status: 200, body:)

      project_item_full, project_item_partial = Github.new.sprint_board_items.first(2)

      expect(project_item_full).to have_attributes id: "I_kwDOHqBmEs5py4Jr", title: "APP-777 - Implement Banner and QR Code",
        assignee_logins: ["john"], repository: "nerdgeschoss/some-project", issue_number: 157, sprint_title: "S2023-13", status: "Done", points: 3
      expect(project_item_partial).to have_attributes id: "I_123", title: "APP-123 - Draft",
        assignee_logins: [], repository: nil, issue_number: nil, sprint_title: nil, status: nil, points: nil
    end
  end
end
