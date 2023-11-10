# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id         :uuid             not null, primary key
#  project_id :uuid             not null
#  harvest_id :bigint           not null
#  reference  :string           not null
#  amount     :decimal(, )      not null
#  state      :string           not null
#  sent_at    :datetime
#  paid_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Invoice < ApplicationRecord
  belongs_to :project

  class << self
    def sync_with_harvest
      project_ids_by_harvest_id = Project.pluck(:harvest_ids, :id).flat_map { |harvest_ids, project_id| harvest_ids.map { |harvest_id| [harvest_id, project_id] } }.to_h
      invoices = HarvestApi.instance.invoices.filter_map do |i|
        next if i.project_id.nil?
        if project_ids_by_harvest_id[i.project_id].nil?
          project_ids_by_harvest_id[i.project_id] = Project.create!(name: i.project_name, harvest_ids: [i.project_id], client_name: i.client_name).id
        end

        {
          project_id: project_ids_by_harvest_id[i.project_id],
          harvest_id: i.id,
          reference: i.reference,
          amount: i.amount,
          state: i.state,
          sent_at: i.sent_at,
          paid_at: i.paid_at
        }
      end
      upsert_all(invoices, unique_by: :harvest_id) if invoices.any?
    end
  end
end
