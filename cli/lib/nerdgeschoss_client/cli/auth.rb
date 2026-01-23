# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class AuthCommands < NerdgeschossClient::CLI::Base
      desc "login", "login to the nerdgeschoss web app"
      def login
        old_token = api.token
        token = ask("Please enter the auth token displayed in the nerdgeschoss app:")
        api.token = token
        viewer = api.viewer

        if viewer
          credentials.save!(viewer.email, token)
        else
          api.token = old_token
          raise PresentableError, "Invalid auth token."
        end

        puts "You're now logged in as #{viewer.display_name} (#{viewer.email})."
      end

      desc "logout", "logout of the nerdgeschoss web app"
      def logout
        credentials.delete!
        puts "You're logged out."
      end

      desc "whoami", "displays the currently logged in user"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      def whoami
        viewer = api.viewer
        if viewer
          if options[:json]
            puts JSON.pretty_generate({
              email: viewer.email,
              display_name: viewer.display_name
            })
          else
            puts "You're logged in as #{viewer.display_name} (#{viewer.email})."
          end
        else
          raise PresentableError.new("You're logged out.")
        end
      end
    end
  end
end
