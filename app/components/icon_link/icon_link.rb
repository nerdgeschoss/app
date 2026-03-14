# frozen_string_literal: true

class Components::IconLink < Components::Base
  prop :title, String
  prop :icon, Icon::IconName
  prop :href, String

  def view_template
    a(href: @href, target: "_blank", rel: "noopener noreferrer") do
      stack(line: :mobile, size: 8) do
        render Icon.new(name: @icon, size: 20)
        text { @title }
      end
    end
  end
end
