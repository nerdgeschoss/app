# frozen_string_literal: true

class Views::Sprints::Index < Views::Base
  prop :sprints, _Any
  prop :permit_create_sprint, _Boolean, default: false
  prop :show_financials, _Boolean, default: false

  def view_template
    render Container.new do
      stack do
        stack(line: :mobile, justify: :"space-between") do
          text(type: :"h1-bold") { "Sprints" }
          render Button.new(title: "New Sprint") if @permit_create_sprint
        end
        stack(size: 32) do
          @sprints.each do |sprint|
            render SprintCard.new(sprint:, show_financials: @show_financials)
          end
        end
        if @sprints.next_page
          a(href: helpers.sprints_path(page: @sprints.next_page)) do
            render Button.new(title: "Load more")
          end
        end
      end
    end
  end
end
