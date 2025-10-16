# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      def update
        project = Project.find_signed!(params[:id])
        new_versions = params[:framework_versions].permit!&.to_h
        project.framework_versions.merge!(new_versions) if new_versions.is_a?(Hash)
        project.save!
        head :no_content
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        head :unauthorized
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
