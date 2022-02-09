class SprintMetrics
  METRICS = [:billable_per_day, :daily_nerd_percentage, :tracked_per_day, :billable_hours, :billable_hours_percentage].freeze
  attr_reader :sprints, :users

  def initialize(sprints, users: sprints.flat_map(&:sprint_feedbacks).map(&:user).uniq.sort_by(&:display_name))
    @sprints = sprints
    @users = users
  end

  def metric(metric, for_user: nil)
    data = calculate_metric(metric)
    data.select! { |e| e[:name] == for_user.display_name } if for_user
    data
  end

  private

  def calculate_metric(metric)
    users.map do |user|
      {
        name: user.display_name,
        data: sprints.select(&:completed?).map do |sprint|
          [sprint.sprint_until, sprint.sprint_feedbacks.find { |e| e.user_id == user.id }&.public_send(metric)&.round(2)]
        end
      }
    end
  end
end
