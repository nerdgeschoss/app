# frozen_string_literal: true

module Types
  class SalaryType < Types::BaseObject
    field :id, ID, null: false
    field :brut, Float, null: false
    field :valid_from, GraphQL::Types::ISO8601Date, null: false
  end
end
