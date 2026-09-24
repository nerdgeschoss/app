# frozen_string_literal: true

class Components::Brand < Components::Base
  def view_template
    stack(line: "mobile", size: 12, align: "center", full_width: "none") do
      render Components::Logo.new
      text(type: "label-heading-primary", color: "text-text-primary-base", uppercase: true) { "Nerdgeschoss" }
    end
  end
end
