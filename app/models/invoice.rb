# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id         :uuid             not null, primary key
#  amount     :decimal(, )      not null
#  paid_at    :datetime
#  reference  :string           not null
#  sent_at    :datetime
#  state      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  harvest_id :bigint           not null
#  project_id :uuid             not null
#
class Invoice < ApplicationRecord
  belongs_to :project
  has_many :time_entries, dependent: :nullify

  class << self
    def sync_with_harvest
      project_id_by_harvest_id = Project.pluck(:harvest_id, :id).to_h
      invoices = HarvestApi.instance.invoices.filter_map do |i|
        next if i.project_id.nil?

        project_id = project_id_by_harvest_id[i.project_id]
        next if project_id_by_harvest_id[i.project_id].nil?

        {
          project_id:,
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
