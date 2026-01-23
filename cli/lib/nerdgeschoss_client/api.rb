module NerdgeschossClient
  class API
    attr_accessor :token, :base_url

    Viewer = Struct.new(:id, :email, :display_name, keyword_init: true)
    User = Struct.new(:id, :email, :display_name, :full_name, :teams, :salaries, :github_handle, :hired_on, :slack_id, keyword_init: true)
    Salary = Struct.new(:id, :brut, :valid_from, keyword_init: true)
    Sprint = Struct.new(:id, :title, :sprint_from, :sprint_until, :total_working_days, :total_holidays, :total_sick_days, :daily_nerd_percentage, :tracked_hours, :billable_hours, :finished_storypoints, :average_rating, :sprint_feedbacks, :tasks, keyword_init: true)
    SprintFeedback = Struct.new(:id, :user, :billable_hours, :finished_storypoints, :retro_rating, :retro_text, :tracked_hours, :daily_nerd_percentage, :billable_per_day, :tracked_per_day, :working_day_count, :holiday_count, :sick_day_count, :non_working_day_count, :leaves, keyword_init: true)
    Task = Struct.new(:id, :issue_number, :title, :status, :labels, :repository, :story_points, keyword_init: true)
    Leave = Struct.new(:id, :title, :days, :status, :type, keyword_init: true)

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

    def sprints
      query = <<~GRAPHQL
        query {
          sprints {
            nodes {
              id
              title
              sprintFrom
              sprintUntil
              totalWorkingDays
              totalHolidays
              totalSickDays
              dailyNerdPercentage
              trackedHours
              billableHours
              finishedStorypoints
              averageRating
            }
          }
        }
      GRAPHQL
      result = execute query

      result.data.sprints.nodes.map do |sprint_data|
        Sprint.new(id: sprint_data.id, title: sprint_data.title, sprint_from: sprint_data.sprint_from, sprint_until: sprint_data.sprint_until, total_working_days: sprint_data.total_working_days, total_holidays: sprint_data.total_holidays, total_sick_days: sprint_data.total_sick_days, daily_nerd_percentage: sprint_data.daily_nerd_percentage, tracked_hours: sprint_data.tracked_hours, billable_hours: sprint_data.billable_hours, finished_storypoints: sprint_data.finished_storypoints, average_rating: sprint_data.average_rating)
      end
    end

    def sprint(id:)
      query = <<~GRAPHQL
        query GetSprint($id: ID!) {
          sprint(id: $id) {
            id
            title
            sprintFrom
            sprintUntil
            totalWorkingDays
            totalHolidays
            totalSickDays
            dailyNerdPercentage
            trackedHours
            billableHours
            finishedStorypoints
            averageRating
            tasks {
              nodes {
                id
                issueNumber
                title
                status
                labels
                repository
                storyPoints
              }
            }
            sprintFeedbacks {
              nodes {
                id
                billableHours
                finishedStorypoints
                retroRating
                retroText
                trackedHours
                dailyNerdPercentage
                billablePerDay
                trackedPerDay
                workingDayCount
                holidayCount
                sickDayCount
                nonWorkingDayCount
                leaves {
                  nodes {
                    id
                    title
                    days
                    status
                    type
                  }
                }
                user {
                  id
                  email
                  displayName
                  fullName
                }
              }
            }
          }
        }
      GRAPHQL
      result = execute query, variables: {id:}

      sprint_data = result.data.sprint
      Sprint.new(id: sprint_data.id,
        title: sprint_data.title,
        sprint_from: sprint_data.sprint_from,
        sprint_until: sprint_data.sprint_until,
        total_working_days: sprint_data.total_working_days,
        total_holidays: sprint_data.total_holidays,
        total_sick_days: sprint_data.total_sick_days,
        daily_nerd_percentage: sprint_data.daily_nerd_percentage,
        tracked_hours: sprint_data.tracked_hours,
        billable_hours: sprint_data.billable_hours,
        finished_storypoints: sprint_data.finished_storypoints,
        average_rating: sprint_data.average_rating,
        tasks: sprint_data.tasks.nodes.map { |task_data|
          Task.new(
            id: task_data.id,
            issue_number: task_data.issue_number,
            title: task_data.title,
            status: task_data.status,
            labels: task_data.labels,
            repository: task_data.repository,
            story_points: task_data.story_points
          )
        },
        sprint_feedbacks: sprint_data.sprint_feedbacks.nodes.map { |feedback_data|
          SprintFeedback.new(
            id: feedback_data.id,
            billable_hours: feedback_data.billable_hours,
            finished_storypoints: feedback_data.finished_storypoints,
            retro_rating: feedback_data.retro_rating,
            retro_text: feedback_data.retro_text,
            tracked_hours: feedback_data.tracked_hours,
            daily_nerd_percentage: feedback_data.daily_nerd_percentage,
            billable_per_day: feedback_data.billable_per_day,
            tracked_per_day: feedback_data.tracked_per_day,
            working_day_count: feedback_data.working_day_count,
            holiday_count: feedback_data.holiday_count,
            sick_day_count: feedback_data.sick_day_count,
            non_working_day_count: feedback_data.non_working_day_count,
            leaves: feedback_data.leaves.nodes.map { |leave_data|
              Leave.new(
                id: leave_data.id,
                title: leave_data.title,
                days: leave_data.days,
                status: leave_data.status,
                type: leave_data.type
              )
            },
            user: User.new(
              id: feedback_data.user.id,
              email: feedback_data.user.email,
              display_name: feedback_data.user.display_name,
              full_name: feedback_data.user.full_name
            )
          )
        })
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
