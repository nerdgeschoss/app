# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class TaskCommands < NerdgeschossClient::CLI::Base
      desc "list", "lists tasks with the given filters"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      method_option :sprint_id, type: :string, desc: "Filter by sprint ID"
      method_option :search, type: :string, desc: "Filter by search term"
      method_option :github, type: :string, desc: "Filter by GitHub repository and issue number (format: owner/repo#issue_number)"
      def list
        tasks = api.tasks(sprint_id: options[:sprint_id], search: options[:search], github: options[:github])
        if options[:json]
          puts JSON.pretty_generate(tasks.map { |task|
            {
              id: task.id,
              title: task.title,
              repository: task.repository,
              issue_number: task.issue_number,
              description: task.description,
              status: task.status,
              labels: task.labels,
              story_points: task.story_points
            }
          })
        else
          tasks.each do |task|
            puts "#{task.title} - #{task.status} (#{task.repository}##{task.issue_number})"
            task.description&.lines&.each do |line|
              puts "  #{line.chomp}"
            end
            puts "  Labels: #{task.labels.join(", ")}"
            puts ""
          end
        end
      end
    end
  end
end
