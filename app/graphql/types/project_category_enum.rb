# frozen_string_literal: true

module Types
  class ProjectCategoryEnum < Types::BaseEnum
    description "Ownership category of a project."

    value "INTERNAL", description: "Projects owned by nerdgeschoss.", value: :internal
    value "CUSTOMERS", description: "Projects for external clients.", value: :customers
  end
end
