# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                 :uuid             not null, primary key
#  archived           :boolean          default(FALSE), not null
#  client_name        :string           not null
#  framework_versions :jsonb            not null
#  name               :string           not null
#  repository         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  harvest_id         :bigint
#
class Project < ApplicationRecord
  self.ignored_columns += ["repositories", "harvest_ids"]
  include Harvest

  has_many :invoices, dependent: :destroy
  has_many :time_entries, dependent: :nullify
  has_many :tasks, dependent: :nullify

  scope :alphabetical, -> { order(name: :asc) }
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def github_url
    "https://github.com/#{repository}" unless repository.blank?
  end

  def harvest_invoice_url
    "https://nerdgeschoss.harvestapp.com/projects/#{harvest_id}?tab=invoices" if harvest_id.present?
  end
end
