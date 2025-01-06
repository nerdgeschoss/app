# frozen_string_literal: true

module Reaction
  module Controller
    extend ActiveSupport::Concern

    included do
      ActionView::Template.register_template_handler(:tsx, Reaction::TsxHandler.new)

      before_action do
        params.deep_transform_keys!(&:underscore) if reaction_request?
      end

      def default_render
        respond_to do |format|
          format.html do
            super
          end
          format.json do
            return head :no_content if reaction_request?
            render json: Response.new(component: "#{controller_path}/#{action_name}", context: view_context).to_s
          end
        end
      end

      def refresh_component_state(component)
        render json: Response.new(component:, context: self).to_s
      end

      def refresh_page
        render json: {refresh: true}
      end

      def reaction_request?
        request.headers["X-Reaction"].present?
      end
    end
  end
end
