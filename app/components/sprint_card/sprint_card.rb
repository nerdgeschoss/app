# frozen_string_literal: true

class Components::SprintCard < Components::Base
  prop :sprint, Sprint
  prop :show_financials, _Boolean, default: false

  def view_template(&block)
    stack do
      render_title
      render Card.new(subtitle: subtitle_component, with_divider: true, &block)
    end
  end

  private

  def render_title
    stack(line: :mobile, align: :center) do
      text(type: :"h3-bold") { "🏃 #{@sprint.title}" }
      text(type: :"h4-regular", color: "label-heading-secondary") { date_range }
    end
  end

  def subtitle_component
    SprintCardSubtitle.new(sprint: @sprint, show_financials: @show_financials)
  end

  def date_range
    from = I18n.l(@sprint.sprint_from, format: :long)
    to = I18n.l(@sprint.sprint_until, format: :long)
    "#{from} – #{to}"
  end

  class SprintCardSubtitle < Components::Base
    include ActiveSupport::NumberHelper

    prop :sprint, Sprint
    prop :show_financials, _Boolean, default: false

    def view_template
      stack(line: :mobile, wrap: true, justify: :"space-between") do
        stack(line: :mobile, full_width: :none, wrap: true) do
          div { render Property.new(prefix: "🔢", value: @sprint.finished_storypoints.to_s, suffix: "pts") }
          div { render Property.new(prefix: "🔢", value: number_to_rounded(@sprint.finished_storypoints_per_day, precision: 1), suffix: "pts/day") }
          div { render Property.new(prefix: "⭐️", value: number_to_rounded(@sprint.average_rating, precision: 1), suffix: "/5") }
          div { render Property.new(prefix: "💻", value: @sprint.total_working_days.to_s, suffix: "days") }
        end
        if @show_financials
          stack(line: :mobile, justify_desktop: :right, full_width: :none, wrap: true) do
            div { render Property.new(prefix: "💸", value: number_to_rounded(@sprint.turnover_per_storypoint, precision: 1), suffix: "per point") }
            div { render Property.new(prefix: "💰", value: number_to_currency(@sprint.turnover), suffix: "Monthly total") }
          end
        end
      end
    end
  end
end
