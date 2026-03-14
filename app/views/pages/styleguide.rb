# frozen_string_literal: true

class Views::Pages::Styleguide < Views::Base
  TEXT_TYPES = [
    :"h1-bold", :"h2-bold", :"h3-bold", :"h3-regular", :"h4-bold", :"h4-regular", :"h5-bold", :"h5-regular",
    :"body-bold", :"body-regular", :"body-secondary", :"body-secondary-regular",
    :"button-bold", :"button-regular", :"button-hold",
    :"caption-primary-bold", :"caption-primary-regular", :"caption-secondary-regular",
    :"card-heading-bold", :"card-heading-regular",
    :"chart-label-primary-bold", :"chart-label-primary-regular",
    :"dropdown-bold", :"dropdown-default",
    :"menu-bold", :"menu-semibold",
    :"tooltip-primary", :"tooltip-secondary",
    :"label-heading-primary", :"label-body-primary",
    :"status-pill"
  ].freeze

  prop :sprint, Sprint
  prop :feedback, SprintFeedback
  prop :days, _Array(SprintFeedback::Day)

  def view_template
    render Container.new do
      stack(size: 32) do
        text(type: :"h1-bold") { "Component Styleguide" }
        section_text
        section_button
        section_avatar
        section_icon
        section_card
        section_container
        section_divider
        section_stack
        section_pill
        section_property
        section_status_pill
        section_star_display
        section_icon_title
        section_text_box
        section_text_field
        section_form_error
        section_tooltip
        section_logo
        section_performance_progress
        section_performance_labels
        section_sprint_card
        section_performance
        section_performance_days
        section_performance_days_large
        section_performance_grid
        section_retro_list
      end
    end
  end

  private

  def section(title, &block)
    stack do
      text(type: :"h3-bold") { title }
      render Divider.new
      yield
    end
  end

  def section_text
    section("Text") do
      TEXT_TYPES.each do |type|
        text(type:) { type.to_s }
      end
      text(type: :"body-regular", color: "label-heading-secondary") { "Body with color" }
      text(type: :"body-regular", uppercase: true) { "Uppercase text" }
    end
  end

  def section_button
    section("Button") do
      stack(line: :mobile) do
        render Button.new(title: "Default Button")
        render Button.new(title: "Disabled Button", disabled: true)
      end
    end
  end

  def section_avatar
    section("Avatar") do
      stack(line: :mobile, align: :center) do
        render Avatar.new(email: "jane@example.com", display_name: "Jane Doe")
        render Avatar.new(email: "jane@example.com", display_name: "Jane Doe", large: true)
        render Avatar.new(email: "unknown@example.com")
      end
    end
  end

  def section_icon
    section("Icon") do
      stack(line: :mobile, wrap: true) do
        [:dashboard, :leave, :logout, :payslip, :sprint, :user, :menu, :close, :project].each do |name|
          stack(align: :center, size: 4) do
            icon(name:, size: 24)
            text(type: :"caption-primary-regular") { name.to_s }
          end
        end
        [:github, :harvest, :react, :puma, :rails, :expo].each do |name|
          stack(align: :center, size: 4) do
            icon(name:, size: 24, full_color: true)
            text(type: :"caption-primary-regular") { name.to_s }
          end
        end
      end
    end
  end

  def section_card
    section("Card") do
      render Card.new(title: "Simple Card") do
        text(type: :"body-regular") { "Card body content goes here." }
      end
      render Card.new(title: "Card with Subtitle", subtitle: "This is a subtitle", with_divider: true) do
        text(type: :"body-regular") { "Content below the divider." }
      end
      render Card.new(title: "Card with Context", context: "Context text") do
        text(type: :"body-regular") { "Card with contextual information." }
      end
    end
  end

  def section_container
    section("Container") do
      render Container.new do
        text(type: :"body-regular") { "Content inside a Container component" }
      end
    end
  end

  def section_divider
    section("Divider") do
      render Divider.new
    end
  end

  def section_stack
    section("Stack") do
      text(type: :"caption-primary-bold") { "Vertical stack (default)" }
      stack(size: 8) do
        text(type: :"body-regular") { "Item 1" }
        text(type: :"body-regular") { "Item 2" }
        text(type: :"body-regular") { "Item 3" }
      end
      text(type: :"caption-primary-bold") { "Horizontal stack (line: :mobile)" }
      stack(line: :mobile, size: 16, align: :center) do
        text(type: :"body-regular") { "Item A" }
        text(type: :"body-regular") { "Item B" }
        text(type: :"body-regular") { "Item C" }
      end
    end
  end

  def section_pill
    section("Pill") do
      stack(line: :mobile) do
        render Pill.new { "Inactive" }
        render Pill.new(active: true) { "Active" }
      end
    end
  end

  def section_property
    section("Property") do
      stack(line: :mobile) do
        render Property.new(prefix: "🔢", value: "13", suffix: "pts")
        render Property.new(prefix: "⭐️", value: "4.2", suffix: "/5")
        render Property.new(prefix: "💻", value: "8", suffix: "days")
      end
    end
  end

  def section_status_pill
    section("StatusPill") do
      stack(line: :mobile) do
        render StatusPill.new(title: "To Do", status: "todo")
        render StatusPill.new(title: "In Progress", status: "in_progress")
        render StatusPill.new(title: "Review", status: "review")
        render StatusPill.new(title: "Done", status: "done")
      end
    end
  end

  def section_star_display
    section("StarDisplay") do
      (1..5).each do |value|
        render StarDisplay.new(value:)
      end
    end
  end

  def section_icon_title
    section("IconTitle") do
      stack(line: :mobile) do
        render IconTitle.new(icon: "🎨", title: "Design", color: "var(--fill-accent-magenta)")
        render IconTitle.new(icon: "💻", title: "Engineering", color: "var(--fill-accent-cyan)")
        render IconTitle.new(icon: "📊", title: "Analytics", color: "var(--fill-accent-green)")
      end
    end
  end

  def section_text_box
    section("TextBox") do
      render TextBox.new(content: "This is a text box with some sample content displayed inside it.")
    end
  end

  def section_text_field
    section("TextField") do
      render TextField.new(label: "Email", name: "email", placeholder: "Enter your email")
      render TextField.new(label: "Filled Field", name: "filled", value: "Some value")
      render TextField.new(label: "Disabled", name: "disabled", value: "Cannot edit", disabled: true)
      render TextField.new(label: "With Errors", name: "errored", value: "Bad value", errors: ["This field is invalid", "Must be at least 3 characters"])
      render TextField.new(label: "Read Only", name: "readonly", value: "Read only value", readonly: true)
    end
  end

  def section_form_error
    section("FormError") do
      render FormError.new(errors: ["Something went wrong", "Please try again"])
    end
  end

  def section_tooltip
    section("Tooltip") do
      render Tooltip.new(content: "This is a tooltip") do
        text(type: :"body-regular") { "Hover over me" }
      end
    end
  end

  def section_logo
    section("Logo") do
      render Logo.new
    end
  end

  def section_performance_progress
    section("PerformanceProgress") do
      render PerformanceProgress.new(total_hours: 60, tracked_hours: 52, billable_hours: 38.5, target_billable_hours: 48)
    end
  end

  def section_performance_labels
    section("PerformanceLabels") do
      render PerformanceLabels.new(billable_hours: 38.5, tracked_hours: 52, target_total_hours: 60)
    end
  end

  def section_sprint_card
    section("SprintCard") do
      render SprintCard.new(sprint: @sprint)
    end
  end

  def section_performance
    section("Performance") do
      render Performance.new(feedback: @feedback)
    end
  end

  def section_performance_days
    section("PerformanceDays") do
      render PerformanceDays.new(days: @days.first(10))
    end
  end

  def section_performance_days_large
    section("PerformanceDaysLarge") do
      render PerformanceDaysLarge.new(days: @days.first(5))
    end
  end

  def section_performance_grid
    section("PerformanceGrid") do
      render PerformanceGrid.new(sprint: @sprint)
    end
  end

  def section_retro_list
    section("RetroList") do
      render RetroList.new(sprint: @sprint)
    end
  end
end
