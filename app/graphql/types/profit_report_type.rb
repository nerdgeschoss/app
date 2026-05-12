# frozen_string_literal: true

module Types
  class ProfitReportType < Types::BaseObject
    description "Profit summary covering a date range. Each entry in months represents one calendar month within the window."

    field :id, ID, null: false,
      description: "Globally unique identifier derived from the report window."
    field :months, [Types::ProfitMonthType], null: false,
      description: "One ProfitMonth per calendar month overlapping the report window."
  end
end
