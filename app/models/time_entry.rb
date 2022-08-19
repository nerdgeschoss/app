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
#

class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :sprint

  scope :billable, -> { where(billable: true) }
end
