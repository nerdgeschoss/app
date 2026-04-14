# frozen_string_literal: true

class Views::Sprints::Card < Components::Base
  DISPLAY_MODES = ["performance", "retro", "points"].freeze

  prop :sprint, Sprint
  prop :show_financials, _Boolean, default: false
  prop :display_mode, String, default: "retro"

  def view_template
    tag(:"turbo-frame", id: "sprint_card_#{@sprint.id}") do
      render SprintCard.new(sprint: @sprint, show_financials: @show_financials) do
        stack(size: 16) do
          render_tabs
          render_content
        end
      end
    end
  end

  private

  def render_tabs
    stack(line: :mobile, size: 4) do
      DISPLAY_MODES.each do |mode|
        a(href: card_sprint_path(@sprint, display: mode)) do
          render Pill.new(active: mode == @display_mode) { mode.capitalize }
        end
      end
    end
  end

  def render_content
    case @display_mode
    when "performance" then render PerformanceGrid.new(sprint: @sprint)
    when "retro" then render RetroList.new(sprint: @sprint)
    when "points" then render StorypointList.new(sprint: @sprint)
    end
  end
end
