# frozen_string_literal: true

module Types
  class ProjectStatusEnum < Types::BaseEnum
    description "Lifecycle state of a project."

    value "ACTIVE", description: "Non-archived projects.", value: :active
    value "ARCHIVED", description: "Archived projects.", value: :archived
  end
end
