# frozen_string_literal: true

class Components::EmployeeCard < Components::Base
  include ActiveSupport::NumberHelper
  include Phlex::Rails::Helpers::NumberWithPrecision

  prop :feedback, SprintFeedback
  prop :show_financials, _Boolean, default: false

  def view_template
    div(class: "employee-card") do
      render_header
      render_section_top
      render Divider.new
      render_section_bottom
    end
  end

  private

  def render_header
    header(class: "employee-card__header") do
      div(class: "employee-card__sprint-info") do
        render Property.new(prefix: "🔢", value: @feedback.finished_storypoints.to_s, suffix: "points")
        render Property.new(prefix: "⭐️", value: @feedback.retro_rating&.to_s, suffix: "/5")
        render Property.new(prefix: "🔢", value: number_with_precision(@feedback.finished_storypoints_per_day, precision: 1), suffix: "pts/day")
        render Property.new(prefix: "💻", value: @feedback.working_day_count.to_s, suffix: "days")
      end
      render Divider.new
      render_turnover if @show_financials && @feedback.turnover.present? && @feedback.turnover_per_storypoint.present?
    end
  end

  def render_turnover
    div(class: "employee-card__turnover-info") do
      render Property.new(prefix: "💸", value: number_to_currency(@feedback.turnover_per_storypoint), suffix: "per point")
      render Property.new(prefix: "💰", value: number_to_currency(@feedback.turnover), suffix: "monthly total")
    end
    div(class: "employee-card__horizontal-divider") do
      render Divider.new
    end
  end

  def render_section_top
    section(class: "employee-card__section employee-card__section--top") do
      render_sprint_overview
      render_daily_overview
      render_retrospective
    end
  end

  def render_sprint_overview
    stack(size: 24) do
      stack(size: 32) do
        render IconTitle.new(icon: "⏱️", title: "Sprint Overview", color: "var(--icon-header-series1)")
        render PerformanceProgress.new(
          total_hours: @feedback.target_total_hours,
          tracked_hours: @feedback.tracked_hours,
          billable_hours: @feedback.billable_hours,
          target_billable_hours: @feedback.target_billable_hours
        )
      end
      render PerformanceLabels.new(
        billable_hours: @feedback.billable_hours,
        tracked_hours: @feedback.tracked_hours,
        target_total_hours: @feedback.target_total_hours
      )
      div(class: "employee-card__horizontal-divider") do
        render Divider.new
      end
    end
  end

  def render_daily_overview
    div(class: "employee-card__daily-overview") do
      stack(size: 24) do
        stack(size: 32) do
          render IconTitle.new(icon: "⏱️", title: "Daily Overview", color: "var(--icon-header-series2)")
          render PerformanceDaysLarge.new(days: @feedback.days)
        end
        div(class: "employee-card__horizontal-divider") do
          render Divider.new
        end
      end
    end
  end

  def render_retrospective
    stack(size: 16) do
      stack(size: 24) do
        render IconTitle.new(icon: "⭐", title: "Retrospective", color: "var(--icon-header-series2-2)")
        render StarDisplay.new(value: @feedback.retro_rating) if @feedback.retro_rating.present?
      end
      stack(size: 16) do
        render TextBox.new(content: @feedback.retro_text) if @feedback.retro_text.present?
        render Button.new(
          title: @feedback.retro_text.present? ? "Edit feedback" : "Leave feedback",
          modal_path: edit_retro_sprint_feedback_path(@feedback)
        )
      end
    end
  end

  def render_section_bottom
    section(class: "employee-card__section employee-card__section--bottom") do
      stack(size: 24) do
        @feedback.days.each_with_index do |day, index|
          render PerformanceDay.new(day:)
          render Divider.new if index < @feedback.days.length - 1
        end
      end
    end
  end
end
