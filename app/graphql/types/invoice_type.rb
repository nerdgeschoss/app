# frozen_string_literal: true

module Types
  class InvoiceType < Types::BaseObject
    description "A project invoice synced from Harvest."

    field :id, ID, null: false, description: "UUID."
    field :reference, String, null: false, description: "Invoice reference number."
    field :amount, Float, null: false, description: "Invoice amount in EUR."
    field :state, String, null: false, description: "Invoice state (e.g. 'open', 'draft', 'paid')."
    field :sent_at, GraphQL::Types::ISO8601DateTime, null: true, description: "When the invoice was sent. Null if not yet sent."
    field :paid_at, GraphQL::Types::ISO8601DateTime, null: true, description: "When the invoice was paid. Null if unpaid."
  end
end
