# frozen_string_literal: true

class Components::TextArea < Components::Base
  prop :name, String
  prop :id, String
  prop :value, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    # Grows with its content; `rows` sets the minimum height.
    textarea(name: @name, id: @id, class: "text-area", style: "--rows: #{@options.fetch(:rows, 2)};", **@options) { @value }
  end
end
