# frozen_string_literal: true

require "rails_helper"

RSpec.describe Components::Logo, type: :component do
  it "renders an img tag with logo class and alt text" do
    html = render_component(described_class.new)

    expect(html.css("img.logo")).to be_present
    expect(html.css("img.logo").first["alt"]).to eq("Nerdgeschoss Logo")
  end
end
