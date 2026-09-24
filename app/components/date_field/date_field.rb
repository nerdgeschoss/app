# frozen_string_literal: true

class Components::DateField < Components::Base
  prop :name, String
  prop :id, String
  prop :value, _Nilable(Date)
  prop :options, Hash, default: -> { {} }

  def view_template
    input(type: "date", name: @name, id: @id, value: @value&.iso8601, class: "date-field", **@options)
  end
end
