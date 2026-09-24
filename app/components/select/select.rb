# frozen_string_literal: true

class Components::Select < Components::Base
  prop :name, String
  prop :id, String
  prop :choices, _Array(_Array(String))
  prop :value, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    select(name: @name, id: @id, class: "select", **@options) do
      @choices.each { |label, value| option(value:, selected: value == @value) { label } }
    end
  end
end
