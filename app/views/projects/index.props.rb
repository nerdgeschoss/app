# frozen_string_literal: true

render "components/current_user"

field :projects, array: true, value: -> { @projects } do
  field :id
  field :name
  field :client_name
  field :open_invoice_count, Integer, value: -> { invoices.count { _1.state == "open" } }
  field :harvest_invoice_url, null: true
  field :repository, null: true
  field :github_url, null: true
  field :framework_versions, JSON
end
field :filter, value: -> { @filter }
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @projects }
