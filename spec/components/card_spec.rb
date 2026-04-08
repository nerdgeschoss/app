# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Card, type: :component do
  it "renders a card with title in the header" do
    html = render_component(described_class.new(title: "My Card") { "body content" })

    expect(html.css("div.card")).to be_present
    expect(html.css(".card__title").text).to include("My Card")
    expect(html.css(".card__content").text).to include("body content")
  end
end
