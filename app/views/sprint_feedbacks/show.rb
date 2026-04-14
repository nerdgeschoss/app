# frozen_string_literal: true

class Views::SprintFeedbacks::Show < Views::Base
  prop :feedback, SprintFeedback
  prop :show_financials, _Boolean, default: false

  def view_template
    render Container.new do
      stack(size: 16) do
        text(type: :"h2-bold", color: "label-heading-primary") { "Sprints" }
        stack do
          stack(line: :mobile, align: :center, size: 8) do
            text(type: :"h3-bold") { "🏃🏻 #{@feedback.sprint.title}" }
            text(type: :"h4-regular", color: "label-heading-secondary") { date_range }
          end
          render EmployeeCard.new(feedback: @feedback, show_financials: @show_financials)
        end
      end
    end
  end

  private

  def date_range
    from = I18n.l(@feedback.sprint.sprint_from, format: :long)
    to = I18n.l(@feedback.sprint.sprint_until, format: :long)
    "#{from} – #{to}"
  end
end
