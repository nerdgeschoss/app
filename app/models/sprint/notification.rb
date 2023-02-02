# frozen_string_literal: true

class Sprint::Notification
  attr_reader :sprint

  def initialize(sprint)
    @sprint = sprint
  end

  def message
    I18n.t("sprints.notifications.sprint_start_content",
      title: sprint.title,
      sprint_during: ApplicationController.helpers.date_range(sprint.sprint_during.min, sprint.sprint_during.max, format: :long),
      working_days: sprint.working_days,
      leaves: leaves_text_lines,
      count: leaves_text_lines.size)
      .concat("\n", birthdays_text_lines(currently_employed_users), anniversaries_text_lines(currently_employed_users))
  end

  private

  def leaves_text_lines
    @leaves_text_lines ||= Leave.includes(:user).during(@sprint.sprint_during).map do |leave|
      "\n- #{leave.user.display_name} (#{ApplicationController.helpers.date_range leave.leave_during.min, leave.leave_during.max, format: :long}): #{leave.title} (#{leave.type})"
    end.join
  end

  def birthdays_text_lines(users)
    users.select { |user| range_covers_repeating_date?(range: @sprint.sprint_during, date: user.born_on) if user.born_on.present? }.map do |user|
      I18n.t("sprints.notifications.birthday_line", user: user.display_name, date: I18n.l(user.hired_on, format: :short))
    end.join
  end

  def anniversaries_text_lines(users)
    users.select { |user| range_covers_repeating_date?(range: @sprint.sprint_during, date: user.hired_on) if user.hired_on.present? }.map do |user|
      I18n.t("sprints.notifications.anniversary_line", user: user.display_name, date: I18n.l(user.hired_on, format: :short))
    end.join
  end

  def currently_employed_users
    @currently_employed_users ||= User.currently_employed
  end

  def range_covers_repeating_date?(range:, date:)
    range.cover?(date.change(year: Date.current.year)) || range.cover?(date.change(year: Date.current.year + 1))
  end
end
