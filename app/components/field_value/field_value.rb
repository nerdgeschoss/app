# frozen_string_literal: true

# The read-only counterpart of an input: a submitted value, optionally a link.
class Components::FieldValue < Components::Base
  prop :value, _Nilable(String)
  prop :href, _Nilable(String)

  def view_template
    if @href
      a(class: "field-value field-value--link", href: @href, target: "_blank", rel: "noopener") { @value }
    else
      div(class: "field-value") { @value }
    end
  end
end
