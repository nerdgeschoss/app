# frozen_string_literal: true

class Views::Base < Components::Base
  def around_template(&block)
    if Current.user
      render Layout.new(user: Current.user) { super(&block) }
    else
      super
    end
  end

  def cache_store = Rails.cache
end
