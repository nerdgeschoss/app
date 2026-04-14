# frozen_string_literal: true

class Components::SelectField < Components::Base
  Option = Data.define(:value, :label).freeze

  prop :name, _Nilable(String), default: nil
  prop :value, _Nilable(String), default: nil
  prop :label, _Nilable(String), default: nil
  prop :options, _Array(Option)
  prop :required, _Boolean, default: false
  prop :disabled, _Boolean, default: false
  prop :readonly, _Boolean, default: false
  prop :include_blank, _Boolean, default: false
  prop :errors, _Nilable(_Array(String)), default: nil

  def view_template
    div(class: "select-field__container") do
      div(class: select_field_classes) do
        div(class: "select-field__content") do
          render_label if @label
          text(block: true) do
            select(
              id: input_id,
              name: @name,
              class: "select-field__input",
              required: @required,
              disabled: @disabled
            ) do
              option(value: "") { "" } if @include_blank
              @options.each do |opt|
                option(value: opt.value, selected: opt.value == @value) { opt.label }
              end
            end
          end
        end
        render FormError.new(errors: @errors) if @errors&.any?
      end
    end
  end

  private

  def select_field_classes
    classes = ["select-field"]
    classes << "select-field--filled" if @value.present?
    classes << "select-field--readonly" if @readonly
    classes << "select-field--disabled" if @disabled
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
    classes = ["select-field__label"]
    classes << "select-field__label--disabled" if @disabled
    classes.join(" ")
  end
end
