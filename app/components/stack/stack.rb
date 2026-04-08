# frozen_string_literal: true

class Components::Stack < Components::Base
  Justify = _Nilable(_Union(:left, :center, :right, :"space-between", :"space-around")).freeze
  Align = _Nilable(_Union(:top, :bottom, :center)).freeze
  Viewport = _Union(:none, :mobile, :tablet, :desktop).freeze

  prop :size, Integer, default: 16
  prop :desktop_size, _Nilable(Integer), default: nil
  prop :tablet_size, _Nilable(Integer), default: nil
  prop :line, Viewport, default: :none
  prop :justify, Justify, default: nil
  prop :justify_tablet, Justify, default: nil
  prop :justify_desktop, Justify, default: nil
  prop :align, Align, default: nil
  prop :align_tablet, Align, default: nil
  prop :align_desktop, Align, default: nil
  prop :grid, Viewport, default: :none
  prop :reverse, Viewport, default: :none
  prop :wrap, _Boolean, default: false
  prop :full_width, _Union(:none, :mobile, :tablet, :desktop, :all), default: :all
  prop :no_shrink, _Boolean, default: false
  prop :class_name, _Nilable(String), default: nil
  prop :id, _Nilable(String), default: nil

  def view_template(&block)
    div(id: @id, class: css_classes, style: css_styles, &block)
  end

  private

  def css_classes
    classes = ["stack"]
    classes << "stack--justify-#{@justify}" if @justify
    classes << "stack--tablet-justify-#{@justify_tablet}" if @justify_tablet
    classes << "stack--desktop-justify-#{@justify_desktop}" if @justify_desktop
    classes << "stack--align-#{@align}" if @align
    classes << "stack--tablet-align-#{@align_tablet}" if @align_tablet
    classes << "stack--desktop-align-#{@align_desktop}" if @align_desktop
    classes << "stack--grid-#{@grid}" if @grid != :none
    classes << "stack--full-width-#{@full_width}" if @full_width != :none
    classes << "stack--no-shrink" if @no_shrink
    classes << "stack--line" if @line == :mobile
    classes << "stack--tablet-line" if @line == :tablet
    classes << "stack--desktop-line" if @line == :desktop
    classes << "stack--reverse" if @reverse == :mobile
    classes << "stack--tablet-reverse" if @reverse == :tablet
    classes << "stack--desktop-reverse" if @reverse == :desktop
    classes << "stack--wrap" if @wrap
    classes << @class_name if @class_name
    classes.join(" ")
  end

  def css_styles
    tablet = @tablet_size || @size
    desktop = @desktop_size || tablet
    "--size: #{@size}px; --tablet-size: #{tablet}px; --desktop-size: #{desktop}px; --size-print: #{@size}rem"
  end
end
