# frozen_string_literal: true

class Components::TextField < Components::Base
  prop :name, _Nilable(String), default: nil
  prop :value, _Nilable(String), default: nil
  prop :label, _Nilable(String), default: nil
  prop :placeholder, _Nilable(String), default: nil
  prop :required, _Boolean, default: false
  prop :disabled, _Boolean, default: false
  prop :readonly, _Boolean, default: false
  prop :errors, _Nilable(_Array(String)), default: nil
  prop :auto_complete, _Nilable(String), default: nil

  def view_template
    div(class: "text-field__container") do
      div(class: text_field_classes) do
        div(class: "text-field__content") do
          render_label if @label
          text(block: true, color: @disabled ? "label-heading-secondary" : nil) do
            input(
              id: input_id,
              name: @name,
              class: "text-field__input",
              readonly: @readonly,
              value: @value || "",
              type: "text",
              placeholder: @placeholder,
              required: @required,
              disabled: @disabled,
              autocomplete: @auto_complete
            )
          end
        end
        render FormError.new(errors: @errors) if @errors&.any?
      end
    end
  end

  private

  def text_field_classes
    classes = ["text-field"]
    classes << "text-field--filled" if @value.present?
    classes << "text-field--readonly" if @readonly
    classes << "text-field--disabled" if @disabled
    classes << "text-field--placeholder" if @placeholder
    classes.join(" ")
  end

  def input_id
    @name&.gsub(/[\[\]]/, "_")&.gsub(/_+$/, "")
  end

  def render_label
    label(class: label_classes, for: input_id) do
      text(type: :"label-heading-primary", color: "label-heading-primary") { @label }
    end
  end

  def label_classes
    classes = ["text-field__label"]
    classes << "text-field__label--disabled" if @disabled
    classes.join(" ")
  end
end
