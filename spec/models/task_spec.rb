# == Schema Information
#
# Table name: tasks
#
#  id           :uuid             not null, primary key
#  sprint_id    :uuid             not null
#  title        :string           not null
#  status       :string           not null
#  story_points :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
