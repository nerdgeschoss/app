# frozen_string_literal: true

class Components::Logo < Components::Base
  def view_template
    img(class: "logo", src: vite_asset_path("/app/components/logo/logo.webp"), alt: "Nerdgeschoss Logo")
  end
end
