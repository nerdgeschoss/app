# frozen_string_literal: true

class Components::TextBox < Components::Base
  prop :content, _Nilable(String), default: nil

  def view_template
    div(class: "text-box") do
      text(type: :"body-secondary-regular", color: "label-body-primary") { @content }
    end
  end
end
