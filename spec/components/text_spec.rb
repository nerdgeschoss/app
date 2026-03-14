# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Text, type: :component do
  it "renders a div with the correct text type class and content" do
    html = render_component(described_class.new(type: :"h5-bold", color: "label-heading-primary") { "Hello" })

    expect(html.css("div.text.text--h5-bold")).to be_present
    expect(html.css("div.text").first["style"]).to include("color: var(--label-heading-primary)")
    expect(html.text).to include("Hello")
  end
end
