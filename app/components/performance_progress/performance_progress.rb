# frozen_string_literal: true

class Components::PerformanceProgress < Components::Base
  include Phlex::Rails::Helpers::NumberWithPrecision
  include Phlex::Rails::Helpers::NumberToPercentage

  prop :total_hours, _Any
  prop :tracked_hours, _Any
  prop :billable_hours, _Any
  prop :target_billable_hours, _Any

  def view_template
    div(class: "performance-progress") do
      div(class: "performance-progress__container") do
        render_svg
        render_percentage
      end
    end
  end

  private

  def percentage_of_required
    (@total_hours.to_f > 0) ? @tracked_hours.to_f / @total_hours.to_f : 1.0
  end

  def percentage_of_billable
    (@target_billable_hours.to_f > 0) ? @billable_hours.to_f / @total_hours.to_f : 1.0
  end

  def percentage_of_target_billable
    (@total_hours.to_f > 0) ? @target_billable_hours.to_f / @total_hours.to_f : 1.0
  end

  def required_stroke_dashoffset
    (408 - percentage_of_required * 204).clamp(204, 408)
  end

  def billable_stroke_dashoffset
    (408 - percentage_of_billable * 204).clamp(204, 408)
  end

  def render_svg
    svg(viewBox: "0 0 150 83", xmlns: "http://www.w3.org/2000/svg") do |s|
      s.circle(
        class: "performance-progress__border-track",
        cx: "75", cy: "75", r: "65",
        transform: "rotate(-180 75 75)"
      )
      s.circle(
        class: "performance-progress__tracked",
        cx: "75", cy: "75", r: "65",
        transform: "rotate(-180 75 75)",
        stroke_dashoffset: required_stroke_dashoffset.round(2)
      )
      s.circle(
        class: "performance-progress__billable",
        cx: "75", cy: "75", r: "65",
        transform: "rotate(-180 75 75)",
        stroke_dashoffset: billable_stroke_dashoffset.round(2)
      )
      render_target_line(s) if percentage_of_target_billable > 0
    end
  end

  def render_target_line(s)
    angle = percentage_of_target_billable * Math::PI - Math::PI
    outer_radius = 70
    inner_radius = 60

    s.line(
      class: "performance-progress__target-line",
      x1: (75 + inner_radius * Math.cos(angle)).round(2),
      y1: (75 + inner_radius * Math.sin(angle)).round(2),
      x2: (75 + outer_radius * Math.cos(angle)).round(2),
      y2: (75 + outer_radius * Math.sin(angle)).round(2)
    )
  end

  def render_percentage
    div(class: "performance-progress__percentage") do
      stack(align: :center, size: 1) do
        text(type: :"chart-label-primary-bold") { number_to_percentage(percentage_of_required * 100, precision: 0) }
        stack(line: :mobile, align: :center, size: 3) do
          text(type: :"chart-label-primary-regular") { number_with_precision(@tracked_hours, precision: 1) }
          text(type: :"chart-label-primary-regular", color: "label-body-secondary") { "hrs" }
        end
      end
    end
  end
end
