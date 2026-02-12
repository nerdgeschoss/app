# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    description "A client or internal project linked to a GitHub repository and Harvest for time tracking."

    field :id, ID, null: false, description: "UUID."
    field :archived, Boolean, null: false, description: "Whether the project is archived and no longer active."
    field :client_name, String, null: false, description: "Name of the client (e.g. 'nerdgeschoss' for internal projects)."
    field :name, String, null: false, description: "Project name."
    field :repository, String, null: true, description: "GitHub repository in 'owner/repo' format. Null if not linked."
    field :github_url, String, null: true, description: "URL to the GitHub repository. Null if not linked."
    field :harvest_invoice_url, String, null: true, description: "URL to the Harvest invoices page for this project. Null if not linked."
    field :open_invoice_amount, Float, null: false, required_permission: :financial_details, description: "Total amount of unpaid invoices in EUR."
    field :open_invoice_count, Integer, null: false, required_permission: :financial_details, description: "Number of unpaid invoices."
    field :last_invoiced, GraphQL::Types::ISO8601Date, null: true, required_permission: :financial_details, description: "Date of the most recent invoice. Null if never invoiced."
    field :invoiced_revenue, Float, null: false, required_permission: :financial_details, description: "Total revenue from paid and sent invoices in EUR."
    field :uninvoiced_revenue, Float, null: false, required_permission: :financial_details, description: "Billable amount not yet invoiced in EUR."
    field :deploy_key, String, null: true, description: "SSH deploy key for the repository. Null if not configured."
    field :tasks, Types::TaskType.connection_type, null: false, description: "GitHub tasks associated with this project."
    field :time_entries, Types::TimeEntryType.connection_type, null: false, description: "Time entries logged against this project."
    field :invoices, Types::InvoiceType.connection_type, null: false, required_permission: :financial_details, description: "Invoices for this project."
  end
end
