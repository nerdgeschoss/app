# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Logo, type: :component do
  it "renders a div with logo class and aria label" do
    html = render_component(described_class.new)

    logo = html.css("div.logo").first
    expect(logo).to be_present
    expect(logo["aria-label"]).to eq("Nerdgeschoss Logo")
  end
end
