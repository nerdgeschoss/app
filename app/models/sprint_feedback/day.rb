class SprintFeedback::Day
  attr_reader :sprint_feedback, :day

  def initialize(sprint_feedback, day)
    @sprint_feedback = sprint_feedback
    @day = day
  end

  def id
    sprint_feedback.id + "-" + day.to_s
  end

  def daily_nerd_message
    @daily_nerd_message ||= sprint_feedback.daily_nerd_messages.find { _1.created_at.to_date == day }
  end

  def leave
    @leave ||= sprint_feedback.leaves.find { _1.days.include?(day) }
  end

  def time_entries
    @time_entries ||= sprint_feedback.sprint.time_entries.filter { _1.created_at.to_date == day && _1.user_id == sprint_feedback.user_id }
  end

  def has_time_entries?
    time_entries.any?
  end

  def working_day?
    leave = leave()
    !day.saturday? && !day.sunday? && (leave.nil? || !leave.non_working?)
  end

  def has_daily_nerd_message?
    !!daily_nerd_message
  end

  def tracked_hours
    @tracked_hours ||= time_entries.sum(&:hours)
  end

  def billable_hours
    @billable_hours ||= time_entries.filter(&:billable?).sum(&:hours)
  end

  def target_total_hours
    working_day? ? SprintFeedback::DEFAULT_HOURLY_GOAL : 0
  end

  def target_billable_hours
    working_day? ? SprintFeedback::DEFAULT_BILLABLE_HOURLY_GOAL : 0
  end
end
