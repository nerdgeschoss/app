# frozen_string_literal: true

class Components::Text < Components::Base
  TextType = _Union(
    :"body-bold", :"body-regular", :"body-secondary", :"body-secondary-regular",
    :"button-bold", :"button-regular", :"button-hold",
    :"caption-primary-bold", :"caption-primary-regular", :"caption-secondary-regular",
    :"card-heading-bold", :"card-heading-regular",
    :"chart-label-primary-bold", :"chart-label-primary-regular",
    :"dropdown-bold", :"dropdown-default",
    :"h1-bold", :"h2-bold", :"h3-bold", :"h3-regular", :"h4-regular", :"h4-bold", :"h5-bold", :"h5-regular",
    :"menu-bold", :"menu-semibold",
    :"tooltip-primary", :"tooltip-secondary",
    :"label-heading-primary", :"label-body-primary",
    :"status-pill"
  ).freeze

  prop :type, TextType, default: :"body-regular"
  prop :color, _Nilable(String), default: nil
  prop :multiline, _Boolean, default: false
  prop :block, _Boolean, default: false
  prop :uppercase, _Boolean, default: false
  prop :no_wrap, _Boolean, default: false

  def view_template(&block)
    div(class: css_classes, style: css_style, &block)
  end

  private

  def css_classes
    classes = ["text", "text--#{@type}"]
    classes << "text--multiline" if @multiline
    classes << "text--block" if @block
    classes << "text--uppercase" if @uppercase
    classes << "text--no-wrap" if @no_wrap
    classes.join(" ")
  end

  def css_style
    return nil unless @color

    "color: var(--#{@color})"
  end
end
