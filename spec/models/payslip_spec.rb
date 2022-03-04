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

RSpec.describe Payslip do
end
