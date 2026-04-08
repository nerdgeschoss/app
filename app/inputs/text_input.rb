# frozen_string_literal: true

class TextInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    component = Components::TextArea.new(
      name: "#{@builder.object_name}[#{attribute_name}]",
      value: object.try(attribute_name)&.to_s,
      label: label_text,
      errors: error_messages,
      required: options[:required] || false,
      disabled: options[:disabled] || false,
      readonly: options[:readonly] || false,
      placeholder: options[:placeholder]
    )
    @builder.template.render(component)
  end

  def label(wrapper_options = nil)
    ""
  end

  def error(wrapper_options = nil)
    ""
  end

  private

  def error_messages
    return nil unless object.respond_to?(:errors)
    msgs = object.errors.full_messages_for(attribute_name)
    msgs.presence
  end

  def label_text
    options[:label] || attribute_name.to_s.humanize
  end
end
