# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :viewer, Types::ViewerType
    def viewer
      current_user
    end

    field :users, Types::UserType.connection_type, null: false do
      argument :team, String, required: false
    end
    def users(team: nil)
      policy_scope(User.all).in_team(team)
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
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
