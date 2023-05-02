# frozen_string_literal: true

class Sprint
  class Notification
    attr_reader :sprint

    def initialize(sprint)
      @sprint = sprint
    end

    def message
      base = I18n.t("sprints.notifications.sprint_start_content",
        title: sprint.title,
        sprint_during: ApplicationController.helpers.date_range(sprint.sprint_during.min, sprint.sprint_during.max,
          format: :long),
        working_days: sprint.working_days,
        leaves: leaves_text_lines.join("\n"),
        count: leaves_text_lines.size)
      [
        base,
        birthdays_text_lines(currently_employed_users),
        anniversaries_text_lines(currently_employed_users)
      ].flatten.compact.join("\n")
    end

    private

    def leaves_text_lines
      @leaves_text_lines ||= Leave.includes(:user).during(@sprint.sprint_during).group_by(&:user).map do |user, leaves|
        dates = leaves.sort_by do |l|
                  l.leave_during.min
                end.map do |leave|
          ApplicationController.helpers.date_range(leave.leave_during.min,
            leave.leave_during.max, format: :short, show_year: false).to_s
        end.to_sentence
        I18n.t("sprints.notifications.leave_line", user: user.display_name, days_count: leaves.map(&:days).flatten.count { |day| @sprint.sprint_during.cover? day },
          dates:)
      end
    end

    def birthdays_text_lines(users)
      users.select do |user|
        range_covers_repeating_date?(range: @sprint.sprint_during, date: user.born_on) if user.born_on.present?
      end.sort_by { |user| date_in_current_year user.born_on }.map do |user|
        I18n.t("sprints.notifications.birthday_line", user: user.display_name,
          date: I18n.l(user.born_on, format: :short))
      end
    end

    def anniversaries_text_lines(users)
      users.select do |user|
        range_covers_repeating_date?(range: @sprint.sprint_during, date: user.hired_on) if user.hired_on.present?
      end.sort_by { |user| date_in_current_year user.hired_on }.map do |user|
        I18n.t("sprints.notifications.anniversary_line", user: user.display_name,
          date: I18n.l(user.hired_on, format: :short))
      end
    end

    def currently_employed_users
      @currently_employed_users ||= User.currently_employed
    end

    def range_covers_repeating_date?(range:, date:)
      range.cover?(date_in_current_year(date)) || range.cover?(date_in_current_year(date) + 1)
    end

    def date_in_current_year(date)
      date.change(year: Date.current.year)
    end
  end
end
