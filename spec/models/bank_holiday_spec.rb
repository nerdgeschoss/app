# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_holidays
#
#  id         :uuid             not null, primary key
#  year       :integer          not null
#  dates      :date             default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe BankHoliday, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
