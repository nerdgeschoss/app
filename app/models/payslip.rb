# == Schema Information
#
# Table name: payslips
#
#  id         :uuid             not null, primary key
#  month      :date
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Payslip < ApplicationRecord
  belongs_to :user

  has_one_attached :pdf
end
