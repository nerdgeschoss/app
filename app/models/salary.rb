# == Schema Information
#
# Table name: salaries
#
#  id           :uuid             not null, primary key
#  user_id      :uuid             not null
#  valid_during :daterange        not null
#  brut         :decimal(, )      not null
#  net          :decimal(, )      not null
#  hgf_hash     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Salary < ApplicationRecord
  include RangeAccessing

  belongs_to :user

  scope :chronologic, -> { order("LOWER(salaries.valid_during) ASC") }

  range_accessor_methods :valid

  validates :valid_during, :brut, :net, presence: true

  def current?
    valid_until.nil?
  end
end
