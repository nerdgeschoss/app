# frozen_string_literal: true

# == Schema Information
#
# Table name: task_users
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :uuid             not null
#  user_id    :uuid             not null
#
class TaskUser < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :user_id, uniqueness: {scope: :task_id}
end
