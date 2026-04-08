# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::TextField, type: :component do
  it "renders an input with a label" do
    html = render_component(described_class.new(name: "email", label: "Email", value: "test@example.com"))

    expect(html.css("input.text-field__input")).to be_present
    expect(html.css("input").first["value"]).to eq("test@example.com")
    expect(html.css("input").first["name"]).to eq("email")
    expect(html.text).to include("Email")
  end

  it "renders errors when present" do
    html = render_component(described_class.new(errors: ["is required"]))

    expect(html.css("div.form-error")).to be_present
    expect(html.text).to include("is required")
  end
end
