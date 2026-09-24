# frozen_string_literal: true

# Wraps a form control with its label and the attribute's validation errors.
class Components::Field < Components::Base
  prop :id, String
  prop :label, String
  prop :control, Components::Base
  prop :errors, _Array(String), default: -> { [] }

  def view_template
    div(class: "field") do
      label(class: "field__label", for: @id) { text(type: "body-bold") { @label } }
      render @control
      if @errors.any?
        div(class: "field__error") do
          text(type: "caption-secondary-regular", color: "text-warning") { @errors.to_sentence }
        end
      end
    end
  end
end
