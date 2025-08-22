# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id            :uuid             not null, primary key
#  billable      :boolean          default(FALSE), not null
#  billable_rate :decimal(, )
#  client_name   :string           not null
#  cost_rate     :decimal(, )
#  hours         :decimal(, )      not null
#  notes         :string
#  project_name  :string           not null
#  rounded_hours :decimal(, )      not null
#  start_at      :datetime
#  task          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  external_id   :string
#  invoice_id    :uuid
#  project_id    :uuid
#  sprint_id     :uuid             not null
#  task_id       :uuid
#  user_id       :uuid             not null
#

class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :sprint
  belongs_to :project, optional: true
  belongs_to :task_object, class_name: "Task", foreign_key: "task_id", optional: true, inverse_of: :time_entries

  scope :billable, -> { where(billable: true) }

  def assign_task
    return if !project_id || notes.blank?
    number = notes.scan(/#(\d+)/).flatten.first
    return if number.nil?

    task = Task.find_by(project_id:, issue_number: number)
    return if task.nil?

    update! task_id: task.id
  end

  def costs
    billable_rate * rounded_hours
  end

  def end_at
    start_at ? start_at + hours.hours : nil
  end
end
