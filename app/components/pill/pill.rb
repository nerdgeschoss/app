# frozen_string_literal: true

class Components::Pill < Components::Base
  prop :active, _Boolean, default: false

  def view_template(&block)
    div(class: css_classes, &block)
  end

  private

  def css_classes
    classes = ["pill"]
    classes << "pill--active" if @active
    classes.join(" ")
  end
end
