# frozen_string_literal: true

module Types
  class PayslipType < Types::BaseObject
    description "A monthly payslip record with an attached PDF."

    field :id, ID, null: false, description: "UUID."
    field :month, GraphQL::Types::ISO8601Date, null: false, description: "The month this payslip covers."
  end
end
