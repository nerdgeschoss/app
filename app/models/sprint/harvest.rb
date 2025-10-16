# frozen_string_literal: true

module Sprint::Harvest
  extend ActiveSupport::Concern

  included do
    def sync_with_harvest
      user_ids_by_email = User.pluck(:email, :id).to_h.merge(User.where.not(harvest_email: nil).pluck(:harvest_email, :id).to_h)
      invoice_ids_by_harvest_id = Invoice.pluck(:harvest_id, :id).to_h
      project_ids_for_harvest = Project.pluck(:harvest_id, :id).to_h
      harvest_entries = HarvestApi.instance.time_entries(from: sprint_from, to: sprint_until)

      deleted_ids = time_entries.pluck(:external_id) - harvest_entries.map(&:id)
      entries = harvest_entries.filter_map do |e|
        next if user_ids_by_email[e.user].nil?

        project_id = project_ids_for_harvest[e.project_id]
        {
          external_id: e.id,
          created_at: e.date,
          start_at: e.start_at,
          hours: e.hours,
          rounded_hours: e.rounded_hours,
          billable: e.billable,
          project_name: e.project,
          project_id:,
          client_name: e.client,
          task: e.task,
          billable_rate: e.billable_rate,
          cost_rate: e.cost_rate,
          notes: e.notes,
          user_id: user_ids_by_email[e.user],
          invoice_id: invoice_ids_by_harvest_id[e.invoice_id]
        }
      end
      transaction do
        time_entries.where(external_id: deleted_ids).delete_all if deleted_ids.any?
        time_entries.upsert_all(entries, unique_by: :external_id) if entries.any?
        time_entries.each(&:assign_task)
        sprint_feedbacks.each do |feedback|
          feedback_entries = time_entries.where(user_id: feedback.user_id)
          feedback.update! tracked_hours: feedback_entries.sum(:hours),
            billable_hours: feedback_entries.billable.sum(:hours),
            turnover: feedback_entries.billable.sum("time_entries.billable_rate * time_entries.rounded_hours")
        end
      end
    end
  end
end
