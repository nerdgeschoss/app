# frozen_string_literal: true

class Components::PerformanceGrid < Components::Base
  prop :sprint, Sprint

  def view_template
    div(class: "performance-grid") do
      sorted_feedbacks.each do |feedback|
        render Performance.new(feedback:)
      end
    end
  end

  private

  def sorted_feedbacks
    @sprint.sprint_feedbacks.sort_by { _1.user.display_name }
  end
end
