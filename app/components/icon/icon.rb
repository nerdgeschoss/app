# frozen_string_literal: true

class Components::Icon < Components::Base
  IconName = _Union(
    :dashboard, :leave, :logout, :payslip, :sprint, :user, :menu,
    :close, :"tooltip-arrow", :"chevron-arrow", :project, :github,
    :harvest, :react, :puma, :rails, :expo
  ).freeze

  prop :name, IconName
  prop :size, Integer, default: 20
  prop :tablet_size, _Nilable(Integer), default: nil
  prop :desktop_size, _Nilable(Integer), default: nil
  prop :color, _Nilable(String), default: nil
  prop :full_color, _Boolean, default: false

  def view_template
    span(class: css_classes, style: css_styles)
  end

  private

  def css_classes
    classes = ["icon", "icon--#{@name}"]
    classes << "icon--full-color" if @full_color
    classes.join(" ")
  end

  def css_styles
    tablet = @tablet_size || @size
    desktop = @desktop_size || tablet
    style = "--icon-size: #{@size}px; --icon-tablet-size: #{tablet}px; --icon-desktop-size: #{desktop}px"
    style += "; --icon-color: var(--#{@color})" if @color
    style
  end
end
