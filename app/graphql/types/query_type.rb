# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "Root queries for the team management API."

    field :viewer, Types::ViewerType,
      description: "The currently authenticated user."
    def viewer
      current_user
    end

    field :users, Types::UserType.connection_type, null: false,
      description: "Paginated list of team members. Results are scoped by the caller's role." do
      argument :team, String, required: false,
        description: "Filter by team name (e.g. 'frontend'). Matches users with the 'team-<name>' role."
      argument :archive, Boolean, required: false, default_value: false,
        description: "When true, includes users who are no longer employed. Defaults to false."
    end
    def users(team: nil, archive: false)
      scope = policy_scope(User.all).in_team(team)
      scope = scope.currently_employed unless archive
      scope
    end

    field :user, Types::UserType, null: false,
      description: "Look up a single user by ID. Requires employee-level access." do
      argument :id, ID, required: true, description: "UUID of the user."
    end
    def user(id:)
      authorize User.find(id), :show
    end

    field :project, Types::ProjectType, null: false do
      argument :id, ID, required: true
    end
    def project(id:)
      project = Project.find_by(repository: id) || Project.find(id)
      authorize project, :show
    end
  end
end
