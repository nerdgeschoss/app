# frozen_string_literal: true

class Components::Stack < Components::Base
  VIEWPORTS = ["none", "mobile", "tablet", "desktop"].freeze
  JUSTIFY = ["left", "center", "right", "space-between", "space-around"].freeze
  ALIGN = ["top", "bottom", "center"].freeze

  prop :id, _Nilable(String)
  prop :size, Integer, default: 16
  prop :tablet_size, _Nilable(Integer)
  prop :desktop_size, _Nilable(Integer)
  prop :line, _Nilable(_Union(*VIEWPORTS))
  prop :justify, _Nilable(_Union(*JUSTIFY))
  prop :justify_tablet, _Nilable(_Union(*JUSTIFY))
  prop :justify_desktop, _Nilable(_Union(*JUSTIFY))
  prop :align, _Nilable(_Union(*ALIGN))
  prop :align_tablet, _Nilable(_Union(*ALIGN))
  prop :align_desktop, _Nilable(_Union(*ALIGN))
  prop :grid, _Nilable(_Union(*VIEWPORTS))
  prop :reverse, _Nilable(_Union(*VIEWPORTS))
  prop :full_width, _Union("all", *VIEWPORTS), default: "all"
  prop :wrap, _Boolean, default: false
  prop :no_shrink, _Boolean, default: false

  def view_template(&block)
    div(id: @id, class: classes, style: sizes, &block)
  end

  private

  def classes
    [
      "stack",
      @justify && "stack--justify-#{@justify}",
      @justify_tablet && "stack--tablet-justify-#{@justify_tablet}",
      @justify_desktop && "stack--desktop-justify-#{@justify_desktop}",
      @align && "stack--align-#{@align}",
      @align_tablet && "stack--tablet-align-#{@align_tablet}",
      @align_desktop && "stack--desktop-align-#{@align_desktop}",
      @grid && "stack--grid-#{@grid}",
      "stack--full-width-#{@full_width}",
      ("stack--line" if @line == "mobile"),
      ("stack--tablet-line" if @line == "tablet"),
      ("stack--desktop-line" if @line == "desktop"),
      ("stack--reverse" if @reverse == "mobile"),
      ("stack--tablet-reverse" if @reverse == "tablet"),
      ("stack--desktop-reverse" if @reverse == "desktop"),
      ("stack--wrap" if @wrap),
      ("stack--no-shrink" if @no_shrink)
    ]
  end

  def sizes
    tablet = @tablet_size || @size
    desktop = @desktop_size || tablet
    "--size: #{@size}px; --tablet-size: #{tablet}px; --desktop-size: #{desktop}px; --size-print: #{@size}rem;"
  end
end
