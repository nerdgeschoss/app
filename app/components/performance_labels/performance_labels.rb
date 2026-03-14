# frozen_string_literal: true

class Components::PerformanceLabels < Components::Base
  include Phlex::Rails::Helpers::NumberWithPrecision

  prop :billable_hours, _Any
  prop :tracked_hours, _Any
  prop :target_total_hours, _Any

  def view_template
    div(class: "performance-labels") do
      ul(class: "performance-labels__list") do
        render_item("billable", "Billable", @billable_hours)
        render_item("tracked", "Tracked", @tracked_hours)
        render_item("goal", "Goal", @target_total_hours)
        render_item("missing", "Missing", missing_hours)
      end
    end
  end

  private

  def missing_hours
    [@target_total_hours.to_f - @tracked_hours.to_f, 0].max
  end

  def render_item(modifier, label, hours)
    li(class: "performance-labels__item performance-labels__item--#{modifier}") do
      span(class: "performance-labels__icon")
      text(type: :"caption-primary-regular", color: "label-caption-secondary") { label }
      span(class: "performance-labels__value") do
        plain "#{number_with_precision(hours, precision: 1)} hrs"
      end
    end
  end
end
