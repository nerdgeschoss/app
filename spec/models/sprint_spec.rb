# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  title         :string           not null
#  sprint_during :daterange        not null
#  working_days  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Sprint, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
