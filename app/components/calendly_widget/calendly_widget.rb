# frozen_string_literal: true

# Embeds a Calendly scheduling page and submits `booking_url` once the visitor has booked.
class Components::CalendlyWidget < Components::Base
  include Phlex::Rails::Helpers::FormWith

  prop :url, String
  prop :booking_url, String
  prop :name, String
  prop :email, String

  def view_template
    data = {
      controller: "calendly-widget",
      calendly_widget_url_value: @url,
      calendly_widget_name_value: @name,
      calendly_widget_email_value: @email
    }
    # Permanent, so a page refresh doesn't morph away the iframe Calendly built inside.
    div(id: "calendly-widget", class: "calendly-widget", data: {**data, turbo_permanent: true}) do
      div(class: "calendly-widget__frame", data: {calendly_widget_target: "frame"})
      form_with(url: @booking_url, method: :post, data: {calendly_widget_target: "form"})
    end
  end
end
