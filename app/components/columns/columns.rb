# frozen_string_literal: true

class Components::Columns < Components::Base
  def view_template(&block)
    div(class: "columns", &block)
  end
end
