# frozen_string_literal: true

raise StandardError, "Database is not empty, use rails db:seed:replant to drop all existing data and reseed." if User.any?

logger = ActiveSupport::Logger.new($stdout)
logger.debug "Seeding process started..."

logger.debug "Creating sprints..."

sprint_start_date = 10.weeks.ago.beginning_of_week
5.times do |i|
  start_date = sprint_start_date + (i * 2).weeks
  end_date = start_date + 2.weeks
  Sprint.create!(
    title: "S#{start_date.year}-#{i.to_s.rjust(2, "0")}",
    sprint_during: start_date..end_date,
    working_days: rand(5..10)
  )
end

# Create current sprint starting last Monday
last_monday = Date.current.beginning_of_week
# 10 working days = 2 weeks from Monday to Friday
end_date = last_monday + 2.weeks - 3.days # This gives us the Friday of the second week

current_sprint = Sprint.create!(
  title: "Sprint 2025-15",
  sprint_during: last_monday..end_date,
  working_days: 10
)

sprints = Sprint.all

logger.debug "Creating users..."
10.times do |i|
  first_name = Faker::Name.first_name
  user = User.create!(
    email: "#{first_name.downcase}@nerdgeschoss.de",
    roles: ["sprinter"],
    first_name:,
    last_name: Faker::Name.last_name,
    born_on: Faker::Date.birthday(min_age: 18, max_age: 65),
    hired_on: Faker::Date.between(from: "2010-01-01", to: "2023-12-31"),
    slack_id: Faker::Alphanumeric.alphanumeric(number: 10),
    github_handle: ["JensRavens"][i]
  )

  brut_salary = Faker::Number.between(from: 3000, to: 8000)
  user.salaries.create!(
    brut: brut_salary,
    net: brut_salary * 0.7,
    valid_from: user.hired_on
  )

  5.times do
    start_date = Faker::Date.between(from: "2022-01-01", to: "2023-12-31")
    end_date = start_date + rand(1..3).days
    user.leaves.create!(
      leave_during: start_date..end_date,
      title: Faker::Lorem.words(number: 3).join(" "),
      type: ["paid", "sick"].sample,
      status: ["approved", "pending_approval"].sample,
      days: (start_date..end_date).to_a
    )
  end

  sprints.each do |sprint|
    user.sprint_feedbacks.create!(
      sprint:,
      daily_nerd_count: Faker::Number.between(from: 0, to: sprint.working_days),
      tracked_hours: Faker::Number.between(from: 20, to: sprint.working_days * 8.0),
      billable_hours: Faker::Number.between(from: 10, to: sprint.working_days * 6.0),
      review_notes: [Faker::Lorem.sentence(word_count: 10), nil, nil].sample,
      finished_storypoints: 3
    )
    2.times do |i|
      user.tasks.create!(
        title: Faker::Lorem.sentence(word_count: 5),
        status: ["Done", "Idea"][i],
        github_id: "PVTI_#{Faker::Alphanumeric.alphanumeric(number: 20)}",
        repository: "#{Faker::App.name}/#{Faker::App.name}",
        issue_number: rand(1..500),
        story_points: [3, 5][i],
        sprint:
      )
    end
  end
end

logger.debug "Creating admin user..."
admin_user = User.create!(email: "admin@nerdgeschoss.de", first_name: "Admin", roles: [:hr, :sprinter])

logger.debug "Creating admin sprint feedback for current sprint..."
admin_user.sprint_feedbacks.create!(
  sprint: current_sprint,
  daily_nerd_count: 0,
  tracked_hours: 0.0,
  billable_hours: 0.0,
  finished_storypoints: 0
)

logger.debug "Creating project and time entries for current sprint..."
# Create a project
project = Project.create!(
  name: "Employee Dashboard",
  client_name: "Internal",
  repositories: ["nerdgeschoss/employee-dashboard"],
  harvest_ids: [12345]
)

# Get some random existing tasks and assign them to current sprint and project
random_tasks = Task.limit(4).to_a
random_tasks.each do |task|
  task.update!(
    sprint: current_sprint,
    project_id: project.id
  )
end

# Create time entries for the first day of the sprint (last Monday)
first_day = last_monday

# Time entry configuration: [hours, billable, notes_context]
time_entries_config = [
  [2.5, true, "development"],
  [2.0, true, "design"],
  [1.5, true, "devops"],
  [1.5, false, "meeting"]
]

time_entries_config.each_with_index do |(hours, billable, context), index|
  TimeEntry.create!(
    external_id: "entry_#{SecureRandom.hex(8)}",
    hours:,
    rounded_hours: hours,
    billable:,
    project_name: billable ? project.name : "Internal",
    client_name: billable ? project.client_name : "Internal",
    task: random_tasks[index].title,
    user: admin_user,
    sprint: current_sprint,
    project:,
    task_id: random_tasks[index].id,
    project_id: project.id,
    created_at: first_day + (9 + index * 2).hours, # 9 AM, 11 AM, 1 PM, 3 PM
    billable_rate: billable ? 100.0 : 0.0,
    cost_rate: 80.0,
    notes: Faker::Lorem.sentence(word_count: rand(8..15))
  )
end

logger.debug "Updating admin sprint feedback with actual data..."
# Update or create the admin user's sprint feedback with real data
admin_sprint_feedback = admin_user.sprint_feedbacks.find_or_create_by(sprint: current_sprint) do |feedback|
  feedback.daily_nerd_count = 0
  feedback.tracked_hours = 0.0
  feedback.billable_hours = 0.0
  feedback.finished_storypoints = 0
end

admin_sprint_feedback.update!(
  tracked_hours: 7.5,
  billable_hours: 6.0,
  finished_storypoints: 5,
  retro_rating: 3,
  retro_text: Faker::Lorem.paragraph(sentence_count: 3)
)

logger.debug "Creating daily nerd message for first day of sprint..."
# Create a daily nerd message for the first day of the current sprint
DailyNerdMessage.create!(
  message: Faker::Quote.most_interesting_man_in_the_world,
  sprint_feedback_id: admin_sprint_feedback.id,
  created_at: first_day + 8.hours # 8 AM on first day
)
