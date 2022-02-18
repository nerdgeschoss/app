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

require "rails_helper"

RSpec.describe Payslip, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
