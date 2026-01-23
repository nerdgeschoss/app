# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class DailyNerdCommands < NerdgeschossClient::CLI::Base
      desc "list", "lists daily nerds"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      method_option :from, type: :string, desc: "Filter messages from this date (YYYY-MM-DD)"
      method_option :to, type: :string, desc: "Filter messages to this date (YYYY-MM-DD)"
      method_option :user, type: :string, desc: "Name or email of the user to filter messages for"
      def list
        user_id = lookup_user(options[:user]) if options[:user].present?
        messages = api.daily_nerd_messages(from_date: options[:from], to_date: options[:to], user_id:)
        if options[:json]
          puts JSON.pretty_generate(messages.map { |message|
            {
              id: message.id,
              message: message.message,
              created_at: message.created_at,
              user: {
                id: message.user.id,
                display_name: message.user.display_name,
                email: message.user.email
              }
            }
          })
        else
          messages.each do |message|
            puts "#{message.user.display_name} (#{message.user.email}), #{message.created_at.to_date}"
            puts "  #{message.message}"
            puts "---"
          end
        end
      end
    end
  end
end
