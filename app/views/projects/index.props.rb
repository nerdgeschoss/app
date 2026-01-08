# frozen_string_literal: true

render "components/current_user"

field :projects, array: true, value: -> { @projects } do
  field :id
  field :name
  field :client_name
  field :open_invoice_amount, Float, null: true, value: -> { open_invoice_amount if helpers.policy(self).financial_details? }
  field :open_invoice_count, Integer, null: true, value: -> { open_invoice_count if helpers.policy(self).financial_details? }
  field :last_invoiced, Date, null: true, value: -> { last_invoiced if helpers.policy(self).financial_details? }
  field :invoiced_revenue, Float, null: true, value: -> { invoiced_revenue if helpers.policy(self).financial_details? }
  field :uninvoiced_revenue, Float, null: true, value: -> { uninvoiced_revenue if helpers.policy(self).financial_details? }
  field :harvest_url, null: true, value: -> { harvest_invoice_url if helpers.policy(self).financial_details? }
  field :repository, null: true
  field :github_url, null: true
  field :framework_versions, JSON
end
field :filter, value: -> { @filter }
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @projects }
