# frozen_string_literal: true

class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options = nil)
    option_items = collection.map do |item|
      if item.is_a?(Array)
        Components::SelectField::Option.new(value: item.last.to_s, label: item.first.to_s)
      else
        label_method = detect_collection_methods.first
        value_method = detect_collection_methods.last
        Components::SelectField::Option.new(value: item.public_send(value_method).to_s, label: item.public_send(label_method).to_s)
      end
    end

    component = Components::SelectField.new(
      name: "#{@builder.object_name}[#{attribute_name}]",
      value: object.try(attribute_name)&.to_s,
      label: label_text,
      options: option_items,
      errors: error_messages,
      required: options[:required] || false,
      disabled: options[:disabled] || false,
      readonly: options[:readonly] || false,
      include_blank: options[:include_blank] || false
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
