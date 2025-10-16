# frozen_string_literal: true

class Project
  module Harvest
    extend ActiveSupport::Concern

    class_methods do
      def sync_with_harvest
        project_ids_by_harvest_id = Project.all.index_by(&:harvest_id)
        HarvestApi.instance.projects.each do |p|
          Rails.error.handle do
            project = project_ids_by_harvest_id[p.id]
            attributes = {
              name: p.name,
              client_name: p.client_name,
              archived: p.archived
            }
            if project
              project.assign_attributes(attributes)
              project.save! if project.changed?
            else
              create!(attributes.merge(harvest_id: p.id))
            end
          end
        end
      end
    end
  end
end
