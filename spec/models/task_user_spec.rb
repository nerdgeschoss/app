# == Schema Information
#
# Table name: task_users
#
#  id         :uuid             not null, primary key
#  task_id    :uuid             not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe TaskUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
