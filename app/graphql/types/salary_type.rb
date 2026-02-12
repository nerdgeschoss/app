# frozen_string_literal: true

module Types
  class SalaryType < Types::BaseObject
    description "A salary record. Multiple records per user represent salary changes over time."

    field :id, ID, null: false, description: "UUID."
    field :brut, Float, null: false, description: "Monthly gross (brutto) salary in EUR."
    field :valid_from, GraphQL::Types::ISO8601Date, null: false,
      description: "Effective date. The most recent record is the current salary."
  end
end
