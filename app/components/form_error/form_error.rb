# frozen_string_literal: true

class Components::FormError < Components::Base
  prop :errors, _Array(String)

  def view_template
    div(class: "form-error") do
      @errors.each do |error|
        text { error }
      end
    end
  end
end
