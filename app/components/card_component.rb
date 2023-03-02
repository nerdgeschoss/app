# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(title: nil, icon: nil, subtitle: nil, context: nil)
    @icon = icon
    @title = title
    @subtitle = subtitle
    @context = context
  end
end
