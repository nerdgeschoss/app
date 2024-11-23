module Reaction
  class TsxHandler
    class << self
      def render(path, assigns, context)
        id = Pathname.new(path).relative_path_from(Rails.root.join("app", "views")).to_s.sub(".tsx", "")
        response = Response.new(component: id, context:)
        <<~HTML
          <meta name="reaction-data" content='#{response}' />
          <div id="root"></div>
        HTML
      end
    end

    def call(template, source)
      "Reaction::TsxHandler.render('#{template.identifier}', assigns, self)"
    end
  end
end
