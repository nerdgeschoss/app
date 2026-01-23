# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class UserCommands < NerdgeschossClient::CLI::Base
      desc "list", "lists users"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      method_option :team, type: :string, desc: "Filter users by team"
      method_option :archive, type: :boolean, default: false, desc: "Include archived users that are not employed anymore"
      def list
        users = api.users(team: options[:team], archive: !!options[:archive])
        if options[:json]
          puts JSON.pretty_generate(users.map { |user|
            {
              id: user.id,
              email: user.email,
              display_name: user.display_name,
              full_name: user.full_name,
              teams: user.teams
            }
          })
        else
          users.each do |user|
            puts "#{user.display_name} (#{user.email})"
          end
        end
      end

      desc "info", "displays information about the given user identified by email or display name"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      def info(name)
        user_id = lookup_user(name)
        user = api.user(id: user_id)
        if options[:json]
          puts JSON.pretty_generate({
            id: user.id,
            email: user.email,
            display_name: user.display_name,
            full_name: user.full_name,
            teams: user.teams,
            github_handle: user.github_handle,
            hired_on: user.hired_on,
            slack_id: user.slack_id,
            salaries: user.salaries.map { |salary|
              {
                id: salary.id,
                brut: salary.brut,
                valid_from: salary.valid_from
              }
            }
          })
        else
          salary = user.salaries.last
          puts "#{user.full_name} (#{user.email})"
          puts "  Teams: #{user.teams.join(", ")}"
          puts "  Salary: #{salary.brut} EUR (since #{salary.valid_from})" if salary
          puts "  GitHub: @#{user.github_handle}" if user.github_handle
          puts "  Hired On: #{user.hired_on}" if user.hired_on
        end
      end
    end
  end
end
