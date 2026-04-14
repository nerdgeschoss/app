# frozen_string_literal: true

class Components::IconTitle < Components::Base
  prop :icon, String
  prop :title, String
  prop :color, String

  def view_template
    div(class: "icon-title", style: "--background-color: #{@color}") do
      span(class: "icon-title__icon") { @icon }
      span(class: "icon-title__text") do
        text(type: :"card-heading-regular") { @title }
      end
    end
  end
end
