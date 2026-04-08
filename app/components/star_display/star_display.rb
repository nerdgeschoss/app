# frozen_string_literal: true

class Components::StarDisplay < Components::Base
  prop :value, Integer

  def view_template
    div(class: "star-display") do
      div(class: "star-display__stars") do
        (1..5).each do |star|
          classes = ["star-display__star"]
          classes << "star-display__star--active" if star <= @value
          div(class: classes.join(" ")) do
            span { "⭐" }
          end
        end
      end
    end
  end
end
