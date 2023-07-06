# frozen_string_literal: true

puts "Seeding process started..."

puts "Truncating database..."
Rake::Task["db:truncate_all"].invoke
puts "Database truncated!"

puts "Creating users..."
10.times do
  puts "Creating user..."
  user = User.create!(
    email: "#{Faker::Name.first_name}@nerdgeschoss.de",
    roles: ["sprinter"],
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    born_on: Faker::Date.birthday(min_age: 18, max_age: 65),
    hired_on: Faker::Date.between(from: "2010-01-01", to: "2023-12-31"),
    slack_id: Faker::Alphanumeric.alphanumeric(number: 10),
    password: "password",
    password_confirmation: "password"
  )
  puts "User created with email: #{user.email}"

  puts "Creating leaves for user..."
  5.times do
    start_date = Faker::Date.between(from: "2022-01-01", to: "2023-12-31")
    end_date = start_date + rand(1..14).days
    Leave.create!(
      leave_during: start_date..end_date,
      title: Faker::Lorem.words(number: 3).join(" "),
      type: ["paid", "sick"].sample,
      status: ["approved", "pending_approval"].sample,
      days: (start_date..end_date).to_a,
      user_id: user.id
    )
  end

  puts "Creating salaries for user..."
  start_date = Faker::Date.between(from: "2021-01-01", to: "2030-12-31")
  end_date = start_date + 1.year
  brut = Faker::Number.between(from: 3_000, to: 10_000)

  Salary.create!(
    user_id: user.id,
    valid_during: start_date..end_date,
    brut:,
    net: brut.to_f * 0.7
  )

  puts "Creating sprints, tasks and sprint feedback for user..."
  5.times do
    start_date = Faker::Date.between(from: "2022-01-01", to: "2023-12-31")
    end_date = start_date + rand(7..14).days
    sprint = Sprint.create!(
      title: "S#{start_date.year}-#{rand(1..36)}",
      sprint_during: start_date..end_date,
      working_days: rand(5..10)
    )

    SprintFeedback.create!(
      user_id: user.id,
      sprint_id: sprint.id,
      daily_nerd_count: Faker::Number.between(from: 1, to: 14),
      tracked_hours: Faker::Number.between(from: 20, to: 47.5),
      billable_hours: Faker::Number.between(from: 10, to: 47.5),
      review_notes: Faker::Lorem.sentence(word_count: 10),
      daily_nerd_entry_dates: Array.new(rand(1..5)) { Faker::Date.between(from: "2020-01-01", to: "2023-12-31") },
      finished_storypoints: Faker::Number.between(from: 0, to: 40)
    )

    task = Task.new(
      title: Faker::Lorem.sentence(word_count: 5),
      status: ["idea", "in_progress", "done"].sample,
      github_id: "PVTI_#{Faker::Alphanumeric.alphanumeric(number: 20)}",
      repository: "#{Faker::App.name}/#{Faker::App.name}",
      issue_number: rand(1..500),
      story_points: [1, 2, 3, 5, 8, 13, 21].sample
    )

    task.sprint = sprint
    task.save!

    TaskUser.create!(
      task: task,
      user: user
    )
  end

end


puts "Creating owner users..."
User.find_or_create_by!(first_name: "Jens", last_name: "Ravens", email: "jens@nerdgeschoss.de") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

User.find_or_create_by!(first_name: "Christian", last_name: "Kroter", email: "christian@nerdgeschoss.de") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
puts "Owner users created!"

puts "Creating admin user..."
User.create!(email: "admin@nerdgeschoss.de") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  puts "Admin user created with email: #{user.email}"
end
