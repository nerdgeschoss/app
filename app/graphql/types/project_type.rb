# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    description "A client or internal project linked to a GitHub repository and Harvest for time tracking."

    field :id, ID, null: false, description: "UUID."
    field :archived, Boolean, null: false, description: "Whether the project is archived and no longer active."
    field :client_name, String, null: false, description: "Name of the client (e.g. 'nerdgeschoss' for internal projects)."
    field :name, String, null: false, description: "Project name."
    field :repository, String, null: true, description: "GitHub repository in 'owner/repo' format. Null if not linked."
    field :deploy_key, String, null: true, description: "SSH deploy key for the repository. Null if not configured."
  end
end
