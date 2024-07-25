# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  name         :string
#  client_name  :string
#  repositories :string           default([]), is an Array
#  harvest_ids  :bigint           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Project < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :time_entries, dependent: :nullify
  has_many :tasks, dependent: :nullify

  class << self
    def sync_with_harvest
      project_ids_by_harvest_id = Project.pluck(:harvest_ids, :id).flat_map { |harvest_ids, project_id| harvest_ids.map { |harvest_id| [harvest_id, project_id] } }.to_h
      HarvestApi.instance.projects.each do |p|
        next if project_ids_by_harvest_id[p.id]
        create!(
          name: p.name,
          client_name: p.client_name,
          harvest_ids: [p.id]
        )
      end
    end
  end

  def merge!(project)
    transaction do
      update!(
        repositories: (repositories + project.repositories).uniq,
        harvest_ids: (harvest_ids + project.harvest_ids).uniq
      )
      project.time_entries.update_all(project_id: id)
      project.tasks.update_all(project_id: id)
      project.invoices.update_all(project_id: id)
      project.delete
    end
  end
end
