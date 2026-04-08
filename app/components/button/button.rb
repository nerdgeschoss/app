# frozen_string_literal: true

class Components::Button < Components::Base
  prop :title, String
  prop :disabled, _Boolean, default: false
  prop :modal_path, _Nilable(String), default: nil

  def view_template
    button(class: "button", disabled: @disabled, **modal_data) do
      text { @title }
    end
  end

  private

  def modal_data
    return {} unless @modal_path

    {data: {controller: "button", action: "button#openModal", button_url_value: @modal_path}}
  end
end
