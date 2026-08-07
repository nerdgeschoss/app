# frozen_string_literal: true

class Components::Pill < Components::Base
  prop :active, _Boolean, default: false

  def view_template(&block)
    div(class: ["pill", ("pill--active" if @active)], &block)
  end
end
