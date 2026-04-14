# frozen_string_literal: true

class ComponentFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    render_text_field(method, options, input_type: "text")
  end

  def date_field(method, options = {})
    render_text_field(method, options, input_type: "date", format_value: ->(v) { v&.to_date&.iso8601 })
  end

  def number_field(method, options = {})
    render_text_field(method, options, input_type: "number")
  end

  def text_area(method, options = {})
    @template.render(Components::TextArea.new(
      name: field_name(method),
      value: value_for(method)&.to_s,
      label: label_for(method, options),
      placeholder: options[:placeholder],
      required: options[:required] || false,
      disabled: options[:disabled] || false,
      readonly: options[:readonly] || false,
      errors: errors_for(method)
    ))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    mapped = Array(choices).map do |item|
      if item.is_a?(Array)
        Components::SelectField::Option.new(label: item.first.to_s, value: item.last.to_s)
      else
        Components::SelectField::Option.new(label: item.to_s, value: item.to_s)
      end
    end

    @template.render(Components::SelectField.new(
      name: field_name(method),
      value: value_for(method)&.to_s,
      label: label_for(method, options),
      options: mapped,
      required: options[:required] || false,
      disabled: options[:disabled] || false,
      readonly: options[:readonly] || false,
      include_blank: options[:include_blank] || false,
      errors: errors_for(method)
    ))
  end

  def submit(value = nil, options = {})
    value ||= submit_default_value
    @template.render(Components::Button.new(title: value, disabled: options[:disabled] || false))
  end

  private

  def render_text_field(method, options, input_type:, format_value: nil)
    raw_value = value_for(method)
    formatted = format_value ? format_value.call(raw_value) : raw_value&.to_s

    @template.render(Components::TextField.new(
      name: field_name(method),
      value: formatted,
      label: label_for(method, options),
      placeholder: options[:placeholder],
      required: options[:required] || false,
      disabled: options[:disabled] || false,
      readonly: options[:readonly] || false,
      auto_complete: options[:autocomplete],
      input_type:,
      errors: errors_for(method)
    ))
  end

  def field_name(method)
    "#{object_name}[#{method}]"
  end

  def value_for(method)
    object&.try(method)
  end

  def label_for(method, options)
    options.delete(:label) || object.class.try(:human_attribute_name, method) || method.to_s.humanize
  end

  def errors_for(method)
    return nil unless object.respond_to?(:errors)
    msgs = object.errors.full_messages_for(method)
    msgs.presence
  end
end
