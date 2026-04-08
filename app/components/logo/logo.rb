# frozen_string_literal: true

class Components::Logo < Components::Base
  def view_template
    div(class: "logo", role: "img", aria_label: "Nerdgeschoss Logo")
  end
end
