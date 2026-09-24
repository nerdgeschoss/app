# frozen_string_literal: true

# Wraps a form control or displayed value with its label and errors.
class Components::Field < Components::Base
  prop :label, String
  prop :id, _Nilable(String)
  prop :errors, _Array(String), default: -> { [] }

  def view_template(&)
    div(class: "field") do
      label(class: "field__label", for: @id) { text(type: "body-bold") { @label } }
      # An element, not a bare yield: the form builder's block returns its control instead of writing it.
      div(class: "field__control", &)
      if @errors.any?
        div(class: "field__error") do
          text(type: "caption-secondary-regular", color: "text-warning") { @errors.to_sentence }
        end
      end
    end
  end
end
