# frozen_string_literal: true

class Components::DependencyIcon < Components::Base
  ICONS = {react: :react, rails: :rails, puma: :puma, expo: :expo}.freeze

  prop :name, String

  def view_template
    icon_name = ICONS[@name.to_sym]
    if icon_name
      div(title: @name) do
        render Icon.new(name: icon_name, full_color: true)
      end
    else
      text(type: :"caption-primary-regular", no_wrap: true) { @name }
    end
  end
end
