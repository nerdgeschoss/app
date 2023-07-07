# frozen_string_literal: true

# == Schema Information
#
# Table name: salaries
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  brut       :decimal(, )      not null
#  net        :decimal(, )      not null
#  hgf_hash   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  valid_from :date             not null
#
class Salary < ApplicationRecord
  belongs_to :user

  scope :chronologic, -> { order(valid_from: :asc) }

  validates :valid_from, :brut, :net, presence: true

  def current?
    user.salaries.max_by(&:valid_from) == self
  end
end
