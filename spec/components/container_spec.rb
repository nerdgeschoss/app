# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Container, type: :component do
  it "renders a container div" do
    html = render_component(described_class.new)
    expect(html.css("div.container")).to be_present
  end
end
