# frozen_string_literal: true

class Views::DailyNerdMessages::Edit < Components::Base
  prop :daily_nerd_message, DailyNerdMessage

  def view_template
    tag(:"turbo-frame", id: "daily_nerd") do
      render Card.new(icon: "📝", title: "Daily Nerd") do
        form_with(model: @daily_nerd_message, url: daily_nerd_message_path(@daily_nerd_message), builder: ComponentFormBuilder) do |f|
          stack do
            f.text_area :message, required: true
            f.submit "Update"
          end
        end
      end
    end
  end
end
