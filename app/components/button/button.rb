# frozen_string_literal: true

class Components::Button < Components::Base
  prop :type, _Union("button", "submit"), default: "button"
  prop :variant, _Union("primary", "danger"), default: "primary"
  prop :modal_url, _Nilable(String)

  def view_template(&)
    button(type: @type, class: ["button", "button--#{@variant}"], data: modal_data) { text(&) }
  end

  private

  def modal_data
    {controller: "button", action: "button#openModal", button_modal_url_value: @modal_url} if @modal_url
  end
end
