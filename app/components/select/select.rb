# frozen_string_literal: true

class Components::Select < Components::Base
  prop :name, String
  prop :id, String
  prop :choices, _Array(_Array(String))
  prop :value, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    div(class: "select") do
      select(name: @name, id: @id, class: "select__input", **@options) do
        @choices.each { |label, value| option(value:, selected: value == @value) { label } }
      end
      span(class: "select__icon") { render Components::Icon.new(name: "chevron-arrow", size: 10, color: "label-body-primary") }
    end
  end
end
