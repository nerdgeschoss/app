# frozen_string_literal: true

module LoginHelper
  def login(user)
    user = users(user) if user.is_a?(Symbol)
    sign_in user
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :system
end
