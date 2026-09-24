# frozen_string_literal: true

# A narrow aside next to the main content on desktop, stacked above it on smaller screens.
class Components::SplitLayout < Components::Base
  prop :aside, Proc

  def view_template(&)
    div(class: "split-layout") do
      stack(size: 24) { @aside.call }
      stack(size: 24, &)
    end
  end
end
