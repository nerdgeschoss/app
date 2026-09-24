# frozen_string_literal: true

# As many columns of at least `min_column_width` as fit, wrapping onto new rows.
class Components::Grid < Components::Base
  prop :min_column_width, Integer, default: 300
  prop :gap, Integer, default: 24

  def view_template(&)
    div(class: "grid", style: "--min-column-width: #{@min_column_width}px; --gap: #{@gap}px;", &)
  end
end
