# frozen_string_literal: true

module ComponentHelper
  def c
    @c ||= ComponentRegistry.new(self) do |c|
      c.register :stack
      # c.register :card, "components/card"
      c.register :columns
      c.register :headline, tag: :h1
      c.register :container
      c.register :card, CardComponent
    end
  end
end
