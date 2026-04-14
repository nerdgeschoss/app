# frozen_string_literal: true

class Components::Divider < Components::Base
  def view_template
    hr(class: "divider")
  end
end
