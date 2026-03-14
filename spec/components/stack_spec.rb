# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Stack, type: :component do
  it "renders a div with stack class and inline styles" do
    html = render_component(described_class.new(size: 24) { "content" })

    expect(html.css("div.stack")).to be_present
    expect(html.css("div.stack").first["style"]).to include("--size: 24px")
    expect(html.text).to include("content")
  end
end
