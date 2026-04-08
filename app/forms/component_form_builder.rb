# frozen_string_literal: true

class ComponentFormBuilder < SimpleForm::FormBuilder
  def submit(value = nil, options = {})
    value ||= submit_default_value
    @template.render(Components::Button.new(title: value, disabled: options[:disabled] || false))
  end
end
