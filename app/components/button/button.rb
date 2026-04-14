# frozen_string_literal: true

class Components::Button < Components::Base
  prop :title, String
  prop :href, _Nilable(String), default: nil
  prop :method, _Nilable(String), default: nil
  prop :confirm, _Nilable(String), default: nil
  prop :disabled, _Boolean, default: false
  prop :modal_path, _Nilable(String), default: nil

  def view_template
    if @href
      a(href: @href, class: "button", **turbo_data, **modal_data) do
        text { @title }
      end
    else
      button(class: "button", disabled: @disabled, **modal_data) do
        text { @title }
      end
    end
  end

  private

  def turbo_data
    data = {}
    data[:turbo_method] = @method if @method
    data[:turbo_confirm] = @confirm if @confirm
    data.empty? ? {} : {data:}
  end

  def modal_data
    return {} unless @modal_path

    {data: {controller: "button", action: "button#openModal", button_url_value: @modal_path}}
  end
end
