# frozen_string_literal: true

class Views::DailyNerdMessages::Show < Components::Base
  prop :daily_nerd_message, _Nilable(_Any), default: nil

  def view_template
    tag(:"turbo-frame", id: "daily_nerd") do
      return unless @daily_nerd_message

      if @daily_nerd_message.new_record?
        render_new_form
      else
        render_existing_message
      end
    end
  end

  private

  def render_new_form
    render Card.new(icon: "📝", title: "Daily Nerd") do
      form_with(model: @daily_nerd_message, url: daily_nerd_messages_path, builder: ComponentFormBuilder) do |f|
        stack do
          f.text_area :message, required: true
          f.submit "Submit"
        end
      end
    end
  end

  def render_existing_message
    render Card.new(icon: "📝", title: "Daily Nerd") do
      stack do
        render TextBox.new(content: @daily_nerd_message.message)
        a(href: edit_daily_nerd_message_path(@daily_nerd_message)) do
          render Button.new(title: "Update")
        end
      end
    end
  end
end
