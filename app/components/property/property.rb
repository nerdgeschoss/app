# frozen_string_literal: true

class Components::Property < Components::Base
  prop :value, _Nilable(String), default: nil
  prop :suffix, _Nilable(String), default: nil
  prop :prefix, _Nilable(String), default: nil

  def view_template
    stack(line: :mobile, size: 3, align: :center, class_name: "property") do
      span(class: "property__prefix") { @prefix } if @prefix
      text(type: :"card-heading-bold") { @value || "-" }
      if @suffix
        text(type: :"card-heading-regular", color: "label-heading-secondary", no_wrap: true) { @suffix }
      end
    end
  end
end
