# frozen_string_literal: true

class Components::Tooltip < Components::Base
  prop :content, _Nilable(String), default: nil

  def view_template(&block)
    div(class: "tooltip") do
      div(class: "tooltip__main", &block)
      if @content
        div(class: "tooltip__anchor") do
          icon(name: :"tooltip-arrow", size: 10)
          div(class: "tooltip__content") do
            text(type: :"tooltip-primary", color: "tooltip-label-default", no_wrap: true) { @content }
          end
        end
      end
    end
  end
end
