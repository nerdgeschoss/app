# frozen_string_literal: true

class Components::Text < Components::Base
  TYPES = [
    "body-bold", "body-regular", "body-secondary", "body-secondary-regular", "button-bold", "button-hold", "button-regular", "caption-primary-bold", "caption-primary-regular", "caption-secondary-regular", "card-heading-bold", "card-heading-regular", "chart-label-primary-bold", "chart-label-primary-regular", "dropdown-bold", "dropdown-default", "h1-bold", "h2-bold", "h3-bold", "h3-regular", "h4-bold", "h4-regular", "h5-bold", "h5-regular", "label-body-primary", "label-heading-primary", "menu-bold", "menu-semibold", "status-pill", "tooltip-primary", "tooltip-secondary"
  ].freeze

  prop :type, _Union(*TYPES), default: "body-regular"
  prop :color, _Nilable(_Union(*COLORS))
  prop :block, _Boolean, default: false
  prop :uppercase, _Boolean, default: false
  prop :no_wrap, _Boolean, default: false
  prop :align, _Nilable(_Union("left", "right", "center"))

  def view_template(&block)
    div(
      class: [
        "text",
        "text--#{@type}",
        ("text--block" if @block),
        ("text--uppercase" if @uppercase),
        ("text--no-wrap" if @no_wrap),
        @align && "text--align-#{@align}"
      ],
      style: "color: #{@color ? "var(--#{@color})" : "inherit"};",
      &block
    )
  end
end
