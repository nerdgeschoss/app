# == Schema Information
#
# Table name: payslips
#
#  id         :uuid             not null, primary key
#  month      :date             not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Payslip < ApplicationRecord
  scope :reverse_chronologic, -> { order(month: :desc) }

  belongs_to :user

  has_one_attached :pdf
end
