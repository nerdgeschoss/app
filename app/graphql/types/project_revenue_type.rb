# frozen_string_literal: true

module Types
  class ProjectRevenueType < Types::BaseObject
    description "Revenue and hours logged for a single project within a profit report row or month."

    field :project, String, null: false,
      description: "Project name as recorded on the time entries."
    field :hours, Float, null: false,
      description: "Sum of rounded billable hours logged on the project."
    field :revenue, Float, null: false,
      description: "Sum of rounded_hours * billable_rate for the project in EUR."
  end
end
