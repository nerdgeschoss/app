# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  sprint_id    :uuid             not null
#  title        :string           not null
#  status       :string           not null
#  story_points :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :sprint

  has_many :task_user, dependent: :delete_all
  has_many :user, through: :task_user, dependent: false
end
