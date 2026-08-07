# frozen_string_literal: true

class Components::Container < Components::Base
  def view_template(&block)
    div(class: "container", &block)
  end
end
