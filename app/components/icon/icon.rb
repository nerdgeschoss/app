# frozen_string_literal: true

class Components::Icon < Components::Base
  NAMES = [
    "chevron-arrow", "close", "dashboard", "expo", "github", "harvest", "leave", "logout", "menu", "payslip", "profit", "project", "puma", "rails", "react", "sprint", "tooltip-arrow", "user"
  ].freeze

  prop :name, _Union(*NAMES)
  prop :size, Integer, default: 20
  prop :tablet_size, _Nilable(Integer)
  prop :desktop_size, _Nilable(Integer)
  prop :color, _Nilable(_Union(*COLORS))
  prop :full_color, _Boolean, default: false

  def view_template
    span(class: ["icon", "icon--#{@name}", ("icon--full-color" if @full_color)], style: sizes)
  end

  private

  def sizes
    tablet = @tablet_size || @size
    desktop = @desktop_size || tablet
    style = "--icon-size: #{@size}px; --icon-tablet-size: #{tablet}px; --icon-desktop-size: #{desktop}px;"
    style += " --icon-color: var(--#{@color});" if @color
    style
  end
end
