# frozen_string_literal: true

class Components::DetailLine < Components::Base
  prop :label, String
  prop :value, String
  prop :icon, _Nilable(Icon::IconName), default: nil
  prop :icon_url, _Nilable(String), default: nil

  def view_template
    stack(line: :mobile, size: 8, align: :center) do
      text(type: :"caption-primary-regular", no_wrap: true) { @label }
      text(type: :"caption-primary-bold", no_wrap: true) { @value }
      if @icon && @icon_url
        a(href: @icon_url, target: "_blank", rel: "noreferrer") do
          render Icon.new(name: @icon, full_color: true)
        end
      end
    end
  end
end
