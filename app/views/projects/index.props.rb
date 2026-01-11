# frozen_string_literal: true

render "components/current_user"

field :presentation_mode, Boolean, value: -> { @presentation_mode }
field :current_sprint, null: true, value: -> { @current_sprint } do
  field :id
  field :title
end
field :projects, array: true, value: -> { @projects } do
  field :id
  field :name
  field :client_name
  field :open_invoice_amount, Float, null: true, value: -> { open_invoice_amount unless root { @hide_financials } }
  field :open_invoice_count, Integer, null: true, value: -> { open_invoice_count unless root { @hide_financials } }
  field :last_invoiced, Date, null: true, value: -> { last_invoiced unless root { @hide_financials } }
  field :invoiced_revenue, Float, null: true, value: -> { invoiced_revenue unless root { @hide_financials } }
  field :uninvoiced_revenue, Float, null: true, value: -> { uninvoiced_revenue unless root { @hide_financials } }
  field :tasks_in_sprint, Integer, value: -> { tasks_in_sprint(root { @current_sprint }) }, null: true
  field :harvest_url, null: true, value: -> { harvest_invoice_url unless root { @hide_financials } }
  field :repository, null: true
  field :github_url, null: true
  field :framework_versions, JSON
end
field :filter, value: -> { @filter }
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @projects }
