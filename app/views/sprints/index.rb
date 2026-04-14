# frozen_string_literal: true

class Views::Sprints::Index < Views::Base
  prop :sprints, _Any
  prop :permit_create_sprint, _Boolean, default: false
  def view_template
    render Container.new do
      stack do
        stack(line: :mobile, justify: :"space-between") do
          text(type: :"h1-bold") { "Sprints" }
          render Button.new(title: "add", modal_path: new_sprint_path) if @permit_create_sprint
        end
        stack(size: 32) do
          @sprints.each do |sprint|
            tag(:"turbo-frame", id: "sprint_card_#{sprint.id}", src: card_sprint_path(sprint))
          end
        end
        if @sprints.next_page
          render Button.new(title: "Load more", href: sprints_path(page: @sprints.next_page))
        end
      end
    end
  end
end
