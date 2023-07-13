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
sprints = Sprint.all

logger.debug "Creating users..."
10.times do |i|
  user = User.create!(
    email: "#{Faker::Name.first_name}@nerdgeschoss.de",
    roles: ["sprinter"],
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    born_on: Faker::Date.birthday(min_age: 18, max_age: 65),
    hired_on: Faker::Date.between(from: "2010-01-01", to: "2023-12-31"),
    slack_id: Faker::Alphanumeric.alphanumeric(number: 10),
    password: "password",
    password_confirmation: "password",
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
      sprint: sprint,
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
User.create!(email: "admin@nerdgeschoss.de", password: "password", roles: [:hr, :sprinter])
