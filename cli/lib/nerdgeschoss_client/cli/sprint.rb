# frozen_string_literal: true

module NerdgeschossClient
  module CLI
    class SprintCommands < NerdgeschossClient::CLI::Base
      desc "list", "lists sprints and their basic stats"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      def list
        sprints = api.sprints
        if options[:json]
          puts JSON.pretty_generate(sprints.map { |sprint|
            {
              id: sprint.id,
              title: sprint.title,
              sprint_from: sprint.sprint_from,
              sprint_until: sprint.sprint_until,
              total_working_days: sprint.total_working_days,
              total_holidays: sprint.total_holidays,
              total_sick_days: sprint.total_sick_days,
              daily_nerd_percentage: sprint.daily_nerd_percentage,
              tracked_hours: sprint.tracked_hours,
              billable_hours: sprint.billable_hours,
              finished_storypoints: sprint.finished_storypoints,
              average_rating: sprint.average_rating
            }
          })
        else
          sprints.each do |sprint|
            puts "#{sprint.title} (#{sprint.sprint_from} - #{sprint.sprint_until})"
            puts "  Total Working Days: #{sprint.total_working_days}"
            puts "  Total Holidays: #{sprint.total_holidays}"
            puts "  Total Sick Days: #{sprint.total_sick_days}"
            puts "  Daily Nerd Percentage: #{sprint.daily_nerd_percentage}"
            puts "  Tracked Hours: #{sprint.tracked_hours}"
            puts "  Billable Hours: #{sprint.billable_hours}"
            puts "  Finished Storypoints: #{sprint.finished_storypoints}"
            puts "  Average Rating: #{sprint.average_rating.round(1)}" if sprint.average_rating
          end
        end
      end

      desc "info", "displays information about the given sprint identified title or the current sprint"
      method_option :json, type: :boolean, default: false, desc: "Output as JSON"
      def info(name = nil)
        sprints = api.sprints
        if name.blank?
          sprint = sprints.first
        else
          sprint = sprints.find { _1.title.casecmp(name).zero? }
          raise PresentableError, "Sprint '#{name}' not found." unless sprint
        end
        sprint = api.sprint(id: sprint.id)
        if options[:json]
          puts JSON.pretty_generate({
            id: sprint.id,
            title: sprint.title,
            sprint_from: sprint.sprint_from,
            sprint_until: sprint.sprint_until,
            total_working_days: sprint.total_working_days,
            total_holidays: sprint.total_holidays,
            total_sick_days: sprint.total_sick_days,
            daily_nerd_percentage: sprint.daily_nerd_percentage,
            tracked_hours: sprint.tracked_hours,
            billable_hours: sprint.billable_hours,
            finished_storypoints: sprint.finished_storypoints,
            average_rating: sprint.average_rating,
            tasks: sprint.tasks.map { |task|
              {
                id: task.id,
                issue_number: task.issue_number,
                title: task.title,
                status: task.status,
                labels: task.labels,
                repository: task.repository,
                story_points: task.story_points
              }
            },
            sprint_feedbacks: sprint.sprint_feedbacks.map { |feedback|
              {
                id: feedback.id,
                user: {
                  id: feedback.user.id,
                  email: feedback.user.email,
                  display_name: feedback.user.display_name,
                  full_name: feedback.user.full_name
                },
                leaves: feedback.leaves.map { |leave|
                  {
                    id: leave.id,
                    title: leave.title,
                    days: leave.days,
                    status: leave.status,
                    type: leave.type
                  }
                },
                billable_hours: feedback.billable_hours,
                finished_storypoints: feedback.finished_storypoints,
                retro_rating: feedback.retro_rating,
                retro_text: feedback.retro_text,
                tracked_hours: feedback.tracked_hours,
                daily_nerd_percentage: feedback.daily_nerd_percentage,
                billable_per_day: feedback.billable_per_day,
                tracked_per_day: feedback.tracked_per_day,
                working_day_count: feedback.working_day_count,
                holiday_count: feedback.holiday_count,
                sick_day_count: feedback.sick_day_count,
                non_working_day_count: feedback.non_working_day_count
              }
            }
          })
        else
          retros = sprint.sprint_feedbacks.select { _1.retro_rating.present? }
          puts "#{sprint.title} (#{sprint.sprint_from} - #{sprint.sprint_until})"
          puts "  Total Working Days: #{sprint.total_working_days}"
          puts "  Total Holidays: #{sprint.total_holidays}"
          puts "  Total Sick Days: #{sprint.total_sick_days}"
          puts "  Daily Nerd Percentage: #{(sprint.daily_nerd_percentage * 100).round(1)}%"
          puts "  Tracked Hours: #{sprint.tracked_hours}"
          puts "  Billable Hours: #{sprint.billable_hours}"
          puts "  Finished Storypoints: #{sprint.finished_storypoints}"
          puts "  Average Rating: #{sprint.average_rating.round(1)}" if sprint.average_rating
          puts ""
          puts "Tasks"
          sprint.tasks.sort_by { |task| [task.repository, task.issue_number] }.each do |task|
            puts "  #{task.repository}##{task.issue_number} #{task.title} [#{task.status}, #{task.story_points}pts]"
          end
          puts ""
          puts "Performance"
          sprint.sprint_feedbacks.sort_by { _1.user.display_name }.each do |feedback|
            puts "  #{feedback.user.display_name}:"
            puts "    Tracked Hours: #{feedback.tracked_hours&.round(1)} (#{feedback.tracked_per_day&.round(1)}/day)"
            puts "    Billable Hours: #{feedback.billable_hours&.round(1)} (#{feedback.billable_per_day&.round(1)}/day)"
            puts "    Finished Storypoints: #{feedback.finished_storypoints}"
            puts "    Leaves:" if feedback.leaves.any?
            feedback.leaves.each do |leave|
              puts "      #{leave.title}: #{leave.days} days (#{leave.status}, #{leave.type})"
            end
          end
          puts ""
          puts "Retrospective" if retros.any?
          retros.each do |retro|
            puts "  #{retro.user.display_name}: Rating #{retro.retro_rating}/5"
            puts "    #{retro.retro_text.gsub("\n", "\n    ")}"
          end
        end
      end
    end
  end
end
