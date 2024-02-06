# frozen_string_literal: true

require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

# Harvest Import Job
scheduler.every "30m" do
  HarvestImportJob.perform_later
end

# Github Import Job
scheduler.every "30m" do
  GithubImportJob.perform_later
end

# Slack Notification Job
scheduler.cron "0 8 * * * Europe/Berlin" do
  SlackNotificationJob.perform_later
end

# Slack Congratulation Job
scheduler.cron "0 9 * * * Europe/Berlin" do
  SlackCongratulationJob.perform_later
end

# Slack Set Status Job
scheduler.cron "0 0 * * * Europe/Berlin" do
  SlackSetStatusJob.perform_later
end
