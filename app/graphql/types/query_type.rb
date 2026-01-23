# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :viewer, Types::ViewerType
    def viewer
      current_user
    end

    field :users, Types::UserType.connection_type, null: false do
      argument :team, String, required: false
      argument :archive, Boolean, required: false, default_value: false
    end
    def users(team: nil, archive: false)
      scope = policy_scope(User.all).in_team(team)
      scope = scope.currently_employed unless archive
      scope
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      authorize User.find(id), :show
    end
  end
end
