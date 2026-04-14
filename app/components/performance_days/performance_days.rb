# frozen_string_literal: true

class Components::PerformanceDays < Components::Base
  prop :days, _Array(SprintFeedback::Day)

  def view_template
    div(class: "performance-days") do
      @days.each do |day|
        div(class: "performance-days__day-container") do
          render_daily_nerd(day)
          render_day_box(day)
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
    div(class: day_classes(day))
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
end
