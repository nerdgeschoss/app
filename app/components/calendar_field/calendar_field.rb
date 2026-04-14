# frozen_string_literal: true

class Components::CalendarField < Components::Base
  prop :name, String
  prop :label, _Nilable(String), default: nil
  prop :errors, _Nilable(_Array(String)), default: nil

  def view_template
    div(
      class: "calendar-field",
      data: {controller: "calendar-field", calendar_field_name_value: @name}
    ) do
      render_label if @label
      div(data: {calendar_field_target: "picker"})
      div(data: {calendar_field_target: "inputs"})
      div(data: {calendar_field_target: "warning"}, style: "display: none") do
        text { "Heads up: Some of the selected days are in the past." }
      end
      render FormError.new(errors: @errors) if @errors&.any?
    end
  end

  private

  def render_label
    label(class: "calendar-field__label") do
      text(type: :"label-heading-primary", color: "label-heading-primary") { @label }
    end
  end
end
