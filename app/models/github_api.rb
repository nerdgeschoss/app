require "graphql/client"
require "graphql/client/http"

class GithubApi
  include Singleton

  def test
    CLIENT.query(TEST_QUERY, variables: { projectId: sprint_project_number })
  end

  private

  def organization_login
    "nerdgeschoss"
  end

  def sprint_project_number
    @sprint_project_number ||= Config.github_sprint_project_id!.to_i
  end

  HTTP = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(_context)
      @headers ||= {
        "Authorization" => "Bearer #{Config.github_access_token!}"
      }
    end
  end

  SCHEMA = GraphQL::Client.load_schema(HTTP)

  CLIENT = GraphQL::Client.new(schema: SCHEMA, execute: HTTP)

  TEST_QUERY = CLIENT.parse <<~GRAPHQL
    query($projectId: Int!) {
      organization(login: "nerdgeschoss") {
        name
        projectV2(number: $projectId) {
          id
          url
        }
      }
    }
    GRAPHQL
end
