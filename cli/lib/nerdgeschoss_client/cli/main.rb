# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class Main < NerdgeschossClient::CLI::Base
      desc "auth", "Manage Authentication"
      subcommand "auth", NerdgeschossClient::CLI::AuthCommands

      desc "user", "Manage Users"
      subcommand "user", NerdgeschossClient::CLI::UserCommands

      desc "sprint", "Manage Sprints"
      subcommand "sprint", NerdgeschossClient::CLI::SprintCommands

      desc "daily_nerd", "Manage Daily Nerd Messages"
      subcommand "daily_nerd", NerdgeschossClient::CLI::DailyNerdCommands
    end
  end
end
