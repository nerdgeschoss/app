# frozen_string_literal: true

require "i18n/tasks"

RSpec.describe "Rubocop" do
  it "does not have any violiations" do
    result = `bundle exec rubocop`
    expect(result).to include("no offenses detected")
  end
end
