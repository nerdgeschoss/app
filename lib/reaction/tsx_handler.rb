# frozen_string_literal: true

module Reaction
  class TsxHandler
    class << self
      def render(path, assigns, context)
        id = Pathname.new(path).relative_path_from(Rails.root.join("app", "views")).to_s.sub(".tsx", "")
        response = Response.new(component: id, context:)
        <<~HTML
          <div id="root"></div>
          <template id="reaction-data" style="display: none;">#{ERB::Util.url_encode(response.to_s)}</template>
        HTML
      end
    end

    def call(template, source)
      "Reaction::TsxHandler.render('#{template.identifier}', assigns, self)"
    end
  end
end
