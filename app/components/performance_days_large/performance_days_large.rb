# frozen_string_literal: true

class Components::PerformanceDaysLarge < Components::Base
  prop :days, _Array(SprintFeedback::Day)

  def view_template
    div(class: "performance-days performance-days--large") do
      @days.each do |day|
        a(href: "#performance-day-#{day.id}", class: "performance-days__day-container") do
          render_daily_nerd(day)
          render_day_box(day)
          render_day_label(day)
        end
      end
    end
  end

  private

  def render_daily_nerd(day)
    div(class: "performance-days__daily-nerd-container") do
      div(class: daily_nerd_classes(day))
    end
  end

  def render_day_box(day)
    div(class: day_classes(day), style: day_style(day)) do
      div(class: "performance-days__target")
    end
  end

  def render_day_label(day)
    div(class: "performance-days__day-label") do
      text(type: :"caption-secondary-regular", color: "label-caption-secondary") do
        I18n.l(day.day, format: "%a").first
      end
    end
  end

  def daily_nerd_classes(day)
    classes = ["performance-days__daily-nerd"]
    classes << "performance-days__daily-nerd--written" if day.has_daily_nerd_message?
    classes.join(" ")
  end

  def day_classes(day)
    classes = ["performance-days__day"]
    if day.leave&.sick?
      classes << "performance-days__day--sick"
    elsif day.leave&.paid?
      classes << "performance-days__day--vacation"
    elsif !day.working_day?
      classes << "performance-days__day--weekend"
    elsif day.has_time_entries?
      classes << "performance-days__day--working"
    end
    classes.join(" ")
  end

  def day_style(day)
    target = day.target_total_hours.to_f
    return nil if target <= 0

    tracked = [(day.tracked_hours.to_f * 100 / target), 100].min
    billable = [(day.billable_hours.to_f * 100 / target), 100].min
    target_billable = [(day.target_billable_hours.to_f * 100 / target), 100].min

    "--tracked-hours: #{tracked.round(1)}%; --billable-hours: #{billable.round(1)}%; --target-billable-hours: #{target_billable.round(1)}%"
  end
end
