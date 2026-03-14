# frozen_string_literal: true

class Components::RetroList < Components::Base
  prop :sprint, Sprint

  def view_template
    stack do
      feedbacks.each do |feedback|
        stack do
          stack(line: :mobile) do
            text(type: :"card-heading-bold", no_wrap: true) { feedback.user.display_name }
            stack(line: :mobile, size: 8, align: :center) do
              span { "⭐" }
              text(type: :"caption-primary-regular") { feedback.retro_rating&.to_s || "-" }
            end
          end
          if feedback.retro_text.present?
            text(multiline: true, type: :"body-regular") { feedback.retro_text }
          end
        end
      end
    end
  end

  private

  def feedbacks
    @sprint.sprint_feedbacks.sort_by { _1.user.display_name }
  end
end
