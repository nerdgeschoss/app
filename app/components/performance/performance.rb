# frozen_string_literal: true

class Components::Performance < Components::Base
  prop :feedback, SprintFeedback

  def view_template
    a(href: sprint_feedback_path(@feedback)) do
      div(class: "performance") do
        stack(size: 11) do
          render_header
          render_stats
          stack(size: 3, justify: :center) do
            render PerformanceProgress.new(
              total_hours: @feedback.target_total_hours,
              tracked_hours: @feedback.tracked_hours,
              billable_hours: @feedback.billable_hours,
              target_billable_hours: @feedback.target_billable_hours
            )
          end
          render PerformanceDays.new(days: @feedback.days)
        end
      end
    end
  end

  private

  def render_header
    stack(justify: :center, align: :center, line: :mobile, size: 6) do
      img(src: @feedback.user.avatar_image(size: 40), class: "performance__avatar")
      div(class: "performance__title") do
        text(type: :"card-heading-bold") { @feedback.user.display_name }
      end
    end
  end

  def render_stats
    stack(line: :mobile, justify: :"space-between") do
      stack(line: :mobile, size: 8) do
        span { "🔢" }
        text(type: :"caption-primary-regular") { @feedback.finished_storypoints.to_s }
      end
      div do
        stack(line: :mobile, size: 8) do
          span { "⭐" }
          text(type: :"caption-primary-regular") { @feedback.retro_rating&.to_s || "-" }
        end
      end
    end
  end
end
