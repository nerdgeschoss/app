# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class Main < NerdgeschossClient::CLI::Base
      desc "auth", "Manage Authentication"
      subcommand "auth", NerdgeschossClient::CLI::AuthCommands

      desc "user", "Manage Users"
      subcommand "user", NerdgeschossClient::CLI::UserCommands
    end
  end
end
