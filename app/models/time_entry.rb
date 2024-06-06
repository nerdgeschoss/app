# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id            :uuid             not null, primary key
#  external_id   :string
#  hours         :decimal(, )      not null
#  rounded_hours :decimal(, )      not null
#  billable      :string           not null
#  project_name  :string           not null
#  client_name   :string           not null
#  task          :string           not null
#  billable_rate :decimal(, )
#  cost_rate     :decimal(, )
#  notes         :string
#  user_id       :uuid             not null
#  sprint_id     :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :uuid
#  task_id       :uuid
#  invoice_id    :uuid
#

class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :sprint

  scope :billable, -> { where(billable: true) }

  def assign_task
    return if !project_id || notes.blank?
    number = notes.scan(/#(\d+)/).flatten.first
    return if number.nil?

    task = Task.find_by(project_id:, issue_number: number)
    return if task.nil?

    update! task_id: task.id
  end
end
