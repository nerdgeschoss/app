# frozen_string_literal: true

class Components::Tooltip < Components::Base
  prop :label, _Nilable(String)

  def view_template(&block)
    div(class: "tooltip", data: {controller: "tooltip"}) do
      div(class: "tooltip__main", &block)
      if @label
        div(class: "tooltip__anchor", data: {tooltip_target: "anchor"}) do
          icon(name: "tooltip-arrow", size: 10)
          div(class: "tooltip__content") do
            text(type: "tooltip-primary", color: "tooltip-label-default", no_wrap: true) { @label }
          end
        end
      end
    end
  end
end
