# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::FormError, type: :component do
  it "renders error messages" do
    html = render_component(described_class.new(errors: ["is required", "is too short"]))

    expect(html.css("div.form-error")).to be_present
    expect(html.text).to include("is required")
    expect(html.text).to include("is too short")
  end
end
