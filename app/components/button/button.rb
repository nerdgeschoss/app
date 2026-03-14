# frozen_string_literal: true

class Components::Button < Components::Base
  prop :title, String
  prop :disabled, _Boolean, default: false

  def view_template
    button(class: "button", disabled: @disabled) do
      text { @title }
    end
  end
end
