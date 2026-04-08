# frozen_string_literal: true

class Views::Projects::Index < Views::Base
  prop :projects, _Any
  prop :filter, String
  prop :current_sprint, _Nilable(Sprint), default: nil
  prop :hide_financials, _Boolean, default: false

  def view_template
    render Container.new do
      stack do
        text(type: :"h1-bold") { "Projects" }
        stack(line: :mobile, size: 4) do
          ["active", "internal", "archived"].each do |f|
            a(href: projects_path(filter: f)) do
              render Pill.new(active: f == @filter) { f }
            end
          end
        end
        render Grid.new(min_column_width: 500) do
          @projects.each do |project|
            render ProjectCard.new(project:, current_sprint: @current_sprint, hide_financials: @hide_financials)
          end
        end
        if @projects.next_page
          a(href: projects_path(filter: @filter, page: @projects.next_page)) do
            render Button.new(title: "more")
          end
        end
      end
    end
  end
end
