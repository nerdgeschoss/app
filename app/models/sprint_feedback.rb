# == Schema Information
#
# Table name: sprint_feedbacks
#
#  id               :uuid             not null, primary key
#  sprint_id        :uuid             not null
#  user_id          :uuid             not null
#  daily_nerd_count :integer
#  tracked_hours    :decimal(, )
#  billable_hours   :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SprintFeedback < ApplicationRecord
  belongs_to :sprint
  belongs_to :user

  scope :ordered, -> { joins(:user).order("users.email ASC") }

  def daily_nerd_percentage
    daily_nerd_count.to_f / working_day_count
  end

  def billable_hours_percentage
    billable_hours.to_f / [0.01, tracked_hours.to_f].max
  end

  def billable_per_day
    billable_hours.to_f / working_day_count
  end

  def working_day_count
    sprint.working_days - holiday_count - sick_day_count
  end

  def holiday_count
    @holiday_count ||= count_days :paid
  end

  def sick_day_count
    @sick_day_count ||= count_days :sick
  end

  private

  def leaves
    @leaves ||= user.leaves.during(sprint.sprint_during)
  end

  def count_days(status)
    leaves.select { |e| e.public_send("#{status}?") }
      .flat_map(&:days).count { |e| sprint.sprint_during.include? e }
  end
end