# frozen_string_literal: true

# == Schema Information
#
# Table name: inventories
#
#  id          :uuid             not null, primary key
#  details     :string
#  name        :string           not null
#  received_at :datetime         not null
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
class Inventory < ApplicationRecord
  belongs_to :user

  validates :name, :received_at, presence: true

  def returned?
    returned_at.present?
  end
end
