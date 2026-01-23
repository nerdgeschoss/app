# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class Base < Thor
      check_unknown_options!
      check_default_type!

      class << self
        def exit_on_failure? = true

        def start(*)
          super
        rescue PresentableError => e
          if ARGV.include?("--json")
            puts JSON.generate(error: e.message)
          else
            puts e.message
          end
        end
      end

      private

      no_commands do
        def api
          @api ||= API.new(token: credentials.auth_token, base_url: NerdgeschossClient::BASE_URL)
        end

        def credentials
          @credentials ||= Credentials.new
        end
      end
    end
  end
end
