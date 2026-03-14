# frozen_string_literal: true

class Components::TextArea < Components::Base
  prop :name, _Nilable(String), default: nil
  prop :value, _Nilable(String), default: nil
  prop :label, _Nilable(String), default: nil
  prop :placeholder, _Nilable(String), default: nil
  prop :required, _Boolean, default: false
  prop :disabled, _Boolean, default: false
  prop :readonly, _Boolean, default: false
  prop :errors, _Nilable(_Array(String)), default: nil

  def view_template
    div(class: "text-area__container") do
      div(class: text_area_classes) do
        div(class: "text-area__content") do
          render_label if @label
          text(block: true, color: @disabled ? "label-heading-secondary" : nil) do
            div(class: "text-area__input-wrapper", data_replicated_value: @value) do
              textarea(
                id: input_id,
                name: @name,
                class: "text-area__input",
                readonly: @readonly,
                placeholder: @placeholder,
                required: @required,
                disabled: @disabled
              ) { @value || "" }
            end
          end
        end
        render FormError.new(errors: @errors) if @errors&.any?
      end
    end
  end

  private

  def text_area_classes
    classes = ["text-area"]
    classes << "text-area--filled" if @value.present?
    classes << "text-area--readonly" if @readonly
    classes << "text-area--disabled" if @disabled
    classes << "text-area--placeholder" if @placeholder
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
    classes = ["text-area__label"]
    classes << "text-area__label--disabled" if @disabled
    classes.join(" ")
  end
end
