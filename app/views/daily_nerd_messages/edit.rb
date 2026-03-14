# frozen_string_literal: true

class Views::DailyNerdMessages::Edit < Components::Base
  prop :daily_nerd_message, DailyNerdMessage

  def view_template
    tag(:"turbo-frame", id: "daily_nerd") do
      render Card.new(icon: "📝", title: "Daily Nerd") do
        simple_form_for(@daily_nerd_message, url: daily_nerd_message_path(@daily_nerd_message)) do |f|
          stack do
            f.input :message, as: :text, required: true
            f.submit "Update"
          end
        end
      end
    end
  end

  private

  def simple_form_for(model, **options, &block)
    options[:builder] ||= ComponentFormBuilder
    output = view_context.simple_form_for(model, **options) { |builder|
      yield Phlex::Rails::Builder.new(builder, component: self)
    }
    raw(output)
  end
end
