# frozen_string_literal: true

class Github
  include Logging

  class QueryExecutionError < StandardError; end

  SprintBoardItem = Struct.new(:id, :title, :assignee_logins, :repository, :issue_number, :sprint_title, :status, :points, keyword_init: true)

  def sprint_board_items
    all_data = []
    after_cursor = nil

    loop do
      data = execute_query(after_cursor:)
      items = data.dig("organization", "project", "items", "nodes")
      logger.debug("Fetched #{items.count} items")
      items.each do |item|
        repository_name = item.dig("content", "repository", "name")
        repository_owner = item.dig("content", "repository", "owner", "login")
        repository = (repository_name && repository_owner) ? "#{repository_owner}/#{repository_name}" : nil

        all_data << SprintBoardItem.new(
          id: item.dig("id"),
          title: item.dig("name", "text") || "",
          assignee_logins: item.dig("content", "assignees", "nodes").to_a.map { |node| node.dig("login") },
          repository:,
          issue_number: item.dig("content", "number"),
          status: item.dig("status", "name").presence,
          sprint_title: item.dig("sprint", "title").presence || item.dig("sprint_backup", "text").presence,
          points: item.dig("points", "number")&.to_i
        )
      end

      page_info = data.dig("organization", "project", "items", "pageInfo")
      after_cursor = page_info.dig("endCursor")

      logger.debug("Cursor for next page: #{after_cursor}")

      break unless page_info.dig("hasNextPage")
    end
    all_data
  end

  private

  def execute_query(after_cursor: nil)
    variables = {
      afterCursor: after_cursor
    }

    headers = {
      "Authorization" => "Bearer #{Config.github_access_token!}",
      "Content-Type" => "application/json"
    }

    Rails.logger.info("Executing query with cursor: #{after_cursor}")
    response = HTTParty.post(
      "https://api.github.com/graphql",
      headers:,
      body: {query:, variables:}.to_json
    )
    raise QueryExecutionError.new("Failed to retrieve data from GitHub API") unless response.ok?
    parsed_response = JSON.parse(response.body)
    raise QueryExecutionError.new(parsed_response["errors"].map { |e| e["message"] }.join(", ")) if parsed_response.key?("errors")

    parsed_response["data"]
  end

  def query
    <<~GRAPHQL
      query RetrieveSprintBoard($afterCursor: String) {
        organization(login: "nerdgeschoss") {
          project: projectV2(number: 1) {
            items(
              first: 100
              after: $afterCursor
            ) {
              pageInfo {
                hasNextPage
                endCursor
              }
              nodes {
                type
                ... on ProjectV2Item {
                  content {
                    ... on DraftIssue {
                      title
                      body
                    }
                    ... on Issue {
                      number
                      repository {
                        name
                        owner {
                          login
                        }
                      }
                      assignees(first: 100) {
                        nodes {
                          login
                        }
                      }
                    }
                    ... on PullRequest {
                      assignees(first: 10) {
                        nodes {
                          login
                        }
                      }
                      title
                      body
                      number
                      repository {
                        name
                        owner {
                          login
                        }
                      }
                    }
                  }
                }
                name: fieldValueByName(name: "Title") {
                  ... on ProjectV2ItemFieldTextValue {
                    text
                  }
                }
                status: fieldValueByName(name: "Status") {
                  ... on ProjectV2ItemFieldSingleSelectValue {
                    name
                  }
                }
                sprint: fieldValueByName(name: "Sprint") {
                  ... on ProjectV2ItemFieldIterationValue {
                    title
                  }
                }
                sprint_backup: fieldValueByName(name: "SprintBackup") {
                  ... on ProjectV2ItemFieldTextValue {
                    text
                  }
                }
                points: fieldValueByName(name: "Points") {
                  ... on ProjectV2ItemFieldNumberValue {
                    number
                  }
                }
                id
              }
            }
          }
        }
      }
    GRAPHQL
  end
end
