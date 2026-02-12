# frozen_string_literal: true

module Types
  class ViewerType < Types::BaseObject
    description "Profile of the authenticated user."

    field :id, ID, null: false, description: "UUID."
    field :display_name, String, null: false, description: "Nickname, first name, or email (first available)."
    field :full_name, String, null: false, description: "First and last name."
    field :email, String, null: false, description: "Primary email used for login and Gravatar."
    field :teams, [String], null: false, method: :team_member_of,
      description: "Team names derived from the user's 'team-*' roles (e.g. ['frontend', 'design'])."
    field :ssh_key, String, description: "Public SSH key. Null if none registered."
    field :github_handle, String, description: "GitHub username used to link tasks and PRs. Null if not configured."
    field :hired_on, GraphQL::Types::ISO8601Date, description: "Employment start date. Null for legacy records."
    field :slack_id, String, description: "Slack member ID (e.g. 'U01ABCDEF'). Null if no linked Slack account."
    field :remaining_holidays, Integer, null: false, description: "Paid vacation days remaining this year."
    field :salaries, SalaryType.connection_type, null: false, description: "Salary history, most recent first."
    field :leaves, LeaveType.connection_type, null: false, description: "Recorded leaves (vacation, sick days, etc.)."
    field :payslips, PayslipType.connection_type, null: false, description: "Payslips for the current year. Most recent first."
  end
end
