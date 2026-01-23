module NerdgeschossClient
  class API
    attr_accessor :token, :base_url

    Viewer = Struct.new(:id, :email, :display_name, keyword_init: true)
    User = Struct.new(:id, :email, :display_name, :full_name, :teams, :salaries, :github_handle, :hired_on, :slack_id, keyword_init: true)
    Salary = Struct.new(:id, :brut, :valid_from, keyword_init: true)

    def initialize(token: Credentials.new.auth_token, base_url: BASE_URL)
      @token = token
      @base_url = base_url
    end

    def viewer
      result = execute <<~GRAPHQL
        query {
          viewer {
            id
            email
            displayName
          }
        }
      GRAPHQL
      return nil if result.data.viewer.nil?

      Viewer.new(id: result.data.viewer.id, email: result.data.viewer.email, display_name: result.data.viewer.display_name)
    end

    def users(team: nil, archive: false)
      query = <<~GRAPHQL
        query AllUsers($team: String, $archive: Boolean!) {
          users(team: $team, archive: $archive) {
            nodes {
              id
              email
              displayName
              fullName
              teams
            }
          }
        }
      GRAPHQL
      result = execute query, variables: {team:, archive:}

      result.data.users.nodes.map do |user_data|
        User.new(id: user_data.id, email: user_data.email, display_name: user_data.display_name, full_name: user_data.full_name, teams: user_data.teams)
      end
    end

    def user(id:)
      query = <<~GRAPHQL
        query GetUser($id: ID!) {
          user(id: $id) {
            id
            email
            displayName
            fullName
            githubHandle
            hiredOn
            slackId
            teams
            salaries {
              nodes {
                id
                brut
                validFrom
              }
            }
          }
        }
      GRAPHQL
      result = execute query, variables: {id:}

      user_data = result.data.user
      User.new(
        id: user_data.id,
        email: user_data.email,
        display_name: user_data.display_name,
        full_name: user_data.full_name,
        teams: user_data.teams,
        github_handle: user_data.github_handle,
        hired_on: user_data.hired_on,
        slack_id: user_data.slack_id,
        salaries: user_data.salaries.nodes.sort_by(&:valid_from).map { |salary_data|
          Salary.new(id: salary_data.id, brut: salary_data.brut, valid_from: salary_data.valid_from)
        }
      )
    end

    private

    def execute(query, variables: {})
      conn = Faraday.new(url: base_url.dup) do |faraday|
        faraday.request :json
        faraday.adapter :net_http
        # faraday.response :logger, nil, {headers: false, bodies: true}
      end

      response = conn.post do |req|
        req.url "/graphql"
        req.headers["Authorization"] = "Bearer #{token}" if token
        req.body = {query:, variables:}
      end

      if response.status >= 500
        raise PresentableError.new("Unknown error. Server responded with: #{response.status}")
      end

      result = JSON.parse(JSON.parse(response.body).deep_transform_keys(&:underscore).to_json, object_class: OpenStruct)

      if result.errors
        raise PresentableError.new(result.errors.map(&:message).join("\n"))
      end

      result
    end
  end
end
