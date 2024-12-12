# frozen_string_literal: true

# == Schema Information
#
# Table name: payslips
#
#  id         :uuid             not null, primary key
#  month      :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#

class Payslip < ApplicationRecord
  scope :reverse_chronologic, -> { order(month: :desc, id: :asc) }

  belongs_to :user

  has_one_attached :pdf

  validates :month, :pdf, presence: true
end
