# frozen_string_literal: true

# The read-only counterpart of an input: a submitted value, optionally a link.
class Components::FieldValue < Components::Base
  prop :value, _Nilable(String)
  prop :href, _Nilable(String)

  def view_template
    if @href
      a(class: "field-value field-value--link", href: @href, target: "_blank", rel: "noopener") do
        span(class: "field-value__text") { @value }
        span(class: "field-value__icon") { render Components::Icon.new(name: "newtab", color: "label-body-primary") }
      end
    else
      div(class: "field-value") { span(class: "field-value__text") { @value } }
    end
  end
end
