# frozen_string_literal: true

# The app-wide default form builder (config.action_view.default_form_builder), so
# `f.text_field` and friends render our input components wrapped in a
# Components::Field carrying the label and the attribute's errors.
class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    text_input(attribute, options, type: "text")
  end

  def email_field(attribute, options = {})
    text_input(attribute, {inputmode: "email", autocomplete: "email"}.merge(options), type: "email")
  end

  def url_field(attribute, options = {})
    text_input(attribute, options, type: "url")
  end

  def date_field(attribute, options = {})
    field(attribute, options) do |name, id, html|
      Components::DateField.new(name:, id:, value: object.public_send(attribute), options: html)
    end
  end

  def text_area(attribute, options = {})
    field(attribute, options) do |name, id, html|
      Components::TextArea.new(name:, id:, value: object.public_send(attribute), options: html)
    end
  end

  def select(attribute, choices = nil, options = {}, html_options = {})
    field(attribute, html_options) do |name, id, html|
      Components::Select.new(name:, id:, choices:, value: object.public_send(attribute), options: html)
    end
  end

  def file_field(attribute, options = {})
    multiple = options.delete(:multiple) || false
    field(attribute, options) do |_name, id, html|
      Components::FileField.new(name: field_name(attribute, multiple:), id:, multiple:, options: html)
    end
  end

  private

  def text_input(attribute, options, type:)
    field(attribute, options) do |name, id, html|
      Components::TextField.new(name:, id:, type:, value: object.public_send(attribute), options: html)
    end
  end

  # Wrap the yielded control in a Components::Field carrying the label and the
  # attribute's errors. `:label` overrides the humanized attribute name.
  def field(attribute, options)
    label = options.delete(:label) || object.class.human_attribute_name(attribute)
    control = yield(field_name(attribute), field_id(attribute), options)
    @template.render(Components::Field.new(id: field_id(attribute), label:, errors: object.errors.full_messages_for(attribute))) do
      @template.render(control)
    end
  end
end
