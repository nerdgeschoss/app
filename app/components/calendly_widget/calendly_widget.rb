# frozen_string_literal: true

# Embeds a Calendly scheduling page and submits `booking_url` once the visitor has booked.
class Components::CalendlyWidget < Components::Base
  include Phlex::Rails::Helpers::FormWith

  prop :url, String
  prop :booking_url, String
  prop :name, String
  prop :email, String

  EMBED_OPTIONS = {hide_event_type_details: 1, hide_landing_page_details: 1, hide_gdpr_banner: 1}.freeze

  def view_template
    data = {
      controller: "calendly-widget",
      calendly_widget_url_value: embed_url,
      calendly_widget_name_value: @name,
      calendly_widget_email_value: @email
    }
    # Permanent, so a page refresh doesn't morph away the iframe Calendly built inside.
    div(id: "calendly-widget", class: "calendly-widget", data: {**data, turbo_permanent: true}) do
      div(class: "calendly-widget__frame", data: {calendly_widget_target: "frame"})
      form_with(url: @booking_url, method: :post, data: {calendly_widget_target: "form"})
    end
  end

  private

  def embed_url
    uri = URI.parse(@url)
    uri.query = URI.encode_www_form(URI.decode_www_form(uri.query.to_s) + EMBED_OPTIONS.to_a)
    uri.to_s
  end
end
