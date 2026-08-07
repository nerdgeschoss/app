# frozen_string_literal: true

sprint = sprints.create :empty, title: "S2023-02", sprint_during: Date.new(2023, 1, 23)..Date.new(2023, 2, 3)

# John's feedback carries explicit costs/turnover; the others keep costs nil
# because their users have no salary (SprintFeedback#recalculate_costs bails out).
john_feedback = sprint_feedbacks.create :sprint_feedback_john, sprint:, user: users.john,
  daily_nerd_count: 3,
  tracked_hours: 30,
  billable_hours: 20,
  review_notes: "Great progress!",
  daily_nerd_entry_dates: ["2023-01-24", "2023-01-25", "2023-01-26"],
  finished_storypoints: 8,
  costs: 2166.67,
  turnover: 150.0
sprint_feedbacks.create :sprint_feedback_2, sprint:, user: users.john_no_slack,
  daily_nerd_count: 3,
  tracked_hours: 25,
  billable_hours: 15,
  review_notes: "Keep up the good work!",
  daily_nerd_entry_dates: ["2023-01-24", "2023-01-25"],
  finished_storypoints: 5
sprint_feedbacks.create :cigdem_current, sprint:, user: users.cigdem, retro_rating: 3
sprint_feedbacks.create :yuki_current, sprint:, user: users.yuki, retro_rating: 5, retro_text: "I liked the sprint"
sprint_feedbacks.create :zacharias_current, sprint:, user: users.zacharias, skip_retro: true

daily_nerd_messages.create :johns_message, sprint_feedback: john_feedback,
  message: "Worked on feature X today", created_at: Time.utc(2023, 1, 24, 9)
daily_nerd_messages.create :johns_second_message, sprint_feedback: john_feedback,
  message: "Continued work on feature X", created_at: Time.utc(2023, 1, 25, 9)

done = tasks.create :done, title: "Implement feature X", sprint:, status: "done",
  github_id: "123456", repository: "RepoName", issue_number: 1, story_points: 3
in_progress = tasks.create :in_progress, title: "Fix bug Y", sprint:, status: "in_progress",
  github_id: "789012", repository: "AnotherRepo", issue_number: 2, story_points: 2

task_users.create :task_user_1, task: done, user: users.john
task_users.create :task_user_2, task: in_progress, user: users.john_no_slack

# A regular working day on an "Employee Dashboard" project: four time entries
# on the sprint's first Monday.
dashboard = projects.create :employee_dashboard, name: "Employee Dashboard", client_name: "nerdgeschoss",
  repository: "nerdgeschoss/employee-dashboard", harvest_id: 12345

[
  ["Frontend Development", 2.5, true],
  ["Graphic Design", 2.0, true],
  ["Backend Development", 1.5, true],
  ["Sprint Planning", 1.5, false]
].each_with_index do |(title, hours, billable), index|
  task = tasks.create sprint:, title:, project: dashboard, status: "In Progress",
    github_id: "demo-day-task-#{index}", repository: "nerdgeschoss/employee-dashboard",
    issue_number: 200 + index, story_points: 2
  time_entries.create external_id: "demo-entry-day-#{index}",
    hours:, rounded_hours: hours, billable:,
    project_name: billable ? dashboard.name : "Internal",
    client_name: billable ? dashboard.client_name : "Internal",
    task: title, task_object: task, project: dashboard,
    user: users.john, sprint:,
    created_at: Time.utc(2023, 1, 23, 9 + index * 2), # 9 AM, 11 AM, 1 PM, 3 PM
    billable_rate: billable ? 100.0 : 0.0, cost_rate: 80.0,
    notes: "##{task.issue_number} work on #{title.downcase}"
end

# Extra clients/projects so the Time Distribution component on the sprint
# feedback page shows every state: many clients (enough to exercise the color
# palette cycling), multiple projects per client, a project with no name, and
# entries with and without a linked task (the latter render as "—").
# Billable entries use rate 120.0 because the monthly revenue rollup sums
# rounded_hours * billable_rate.

task = tasks.create sprint:, title: "Events Index Table View", issue_number: 3115,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-0"
time_entries.create external_id: "demo-entry-dist-0", user: users.john, sprint:,
  client_name: "Krasser Stoff Merchandising GmbH", project_name: "Branding / Website",
  task: "Events Index Table View", task_object: task, hours: 11.0, rounded_hours: 11.0,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

# A project with no name.
task = tasks.create sprint:, title: "re:sale Page - review", issue_number: 3109,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-1"
time_entries.create external_id: "demo-entry-dist-1", user: users.john, sprint:,
  client_name: "Krasser Stoff Merchandising GmbH", project_name: "",
  task: "re:sale Page - review", task_object: task, hours: 2.7, rounded_hours: 2.7,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Implement Anlagerichtlinien BV IVV", issue_number: 33,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-2"
time_entries.create external_id: "demo-entry-dist-2", user: users.john, sprint:,
  client_name: "LAIC Capital GmbH", project_name: "Branding / Website",
  task: "Implement Anlagerichtlinien BV IVV", task_object: task, hours: 4.5, rounded_hours: 4.5,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Implement Anlagerichtlinien BV IVV", issue_number: 34,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-3"
time_entries.create external_id: "demo-entry-dist-3", user: users.john, sprint:,
  client_name: "LAIC Capital GmbH", project_name: "Union Investment Onboarding",
  task: "Implement Anlagerichtlinien BV IVV", task_object: task, hours: 3.0, rounded_hours: 3.0,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

# An entry without a linked task (renders as "—").
time_entries.create external_id: "demo-entry-dist-4", user: users.john, sprint:,
  client_name: "LAIC Capital GmbH", project_name: "Union Investment Onboarding",
  task: "misc", hours: 1.4, rounded_hours: 1.4,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Implement Anlagerichtlinien BV IVV", issue_number: 35,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-5"
time_entries.create external_id: "demo-entry-dist-5", user: users.john, sprint:,
  client_name: "LAIQON AG", project_name: "LAIC Portal / iOS App",
  task: "Implement Anlagerichtlinien BV IVV", task_object: task, hours: 1.5, rounded_hours: 1.5,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

time_entries.create external_id: "demo-entry-dist-6", user: users.john, sprint:,
  client_name: "LAIQON AG", project_name: "LAIC Portal / iOS App",
  task: "misc", hours: 1.5, rounded_hours: 1.5,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Artist page: inline linking tags not expanded", issue_number: 1571,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-7"
time_entries.create external_id: "demo-entry-dist-7", user: users.john, sprint:,
  client_name: "recordsale & musicberlin GmbH", project_name: "recordsale",
  task: "Artist page: inline linking tags not expanded", task_object: task, hours: 2.0, rounded_hours: 2.0,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Deprecated records filter incorrect", issue_number: 1578,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-8"
time_entries.create external_id: "demo-entry-dist-8", user: users.john, sprint:,
  client_name: "recordsale & musicberlin GmbH", project_name: "recordsale",
  task: "Deprecated records filter incorrect", task_object: task, hours: 1.5, rounded_hours: 1.5,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

task = tasks.create sprint:, title: "Update album detail width and position", issue_number: 1587,
  repository: "nerdgeschoss/app", status: "Done", story_points: 2, github_id: "demo-dist-task-9"
time_entries.create external_id: "demo-entry-dist-9", user: users.john, sprint:,
  client_name: "recordsale & musicberlin GmbH", project_name: "flipvinyl",
  task: "Update album detail width and position", task_object: task, hours: 1.5, rounded_hours: 1.5,
  billable: true, billable_rate: 120.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)

time_entries.create external_id: "demo-entry-dist-10", user: users.john, sprint:,
  client_name: "Nerdgeschoss", project_name: "Non-billable",
  task: "misc", hours: 4.1, rounded_hours: 4.1,
  billable: false, billable_rate: 0.0, cost_rate: 60.0, created_at: Time.utc(2023, 1, 23, 9)
