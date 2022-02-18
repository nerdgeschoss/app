# == Schema Information
#
# Table name: sprint_feedbacks
#
#  id               :uuid             not null, primary key
#  sprint_id        :uuid             not null
#  user_id          :uuid             not null
#  daily_nerd_count :integer
#  tracked_hours    :decimal(, )
#  billable_hours   :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  review_notes     :string
#

require "rails_helper"

RSpec.describe SprintFeedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
