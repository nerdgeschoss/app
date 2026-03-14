# frozen_string_literal: true

class Components::Grid < Components::Base
  prop :min_column_width, Integer, default: 300
  prop :gap, Integer, default: 24
  prop :horizontal_gap, _Nilable(Integer), default: nil

  def view_template(&block)
    div(class: "grid", style: css_styles, &block)
  end

  private

  def css_styles
    h_gap = @horizontal_gap || @gap
    "--min-width: #{@min_column_width}px; --gap: #{@gap}px; --horizontal-gap: #{h_gap}px"
  end
end
