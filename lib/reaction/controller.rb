module Reaction
  module Controller
    extend ActiveSupport::Concern

    included do
      ActionView::Template.register_template_handler(:tsx, Reaction::TsxHandler.new)

      def default_render
        respond_to do |format|
          format.html do
            super
          end
          format.json do
            render json: Response.new(component: "#{controller_path}/#{action_name}", context: self).to_s
          end
        end
      end
    end
  end
end
