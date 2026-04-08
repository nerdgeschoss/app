# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Button, type: :component do
  it "renders a button with the title" do
    html = render_component(described_class.new(title: "Login"))

    expect(html.css("button.button")).to be_present
    expect(html.text).to include("Login")
  end
end
