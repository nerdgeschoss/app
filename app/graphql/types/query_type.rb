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

    field :sprints, Types::SprintType.connection_type, null: false
    def sprints
      policy_scope(Sprint.all.reverse_chronologic.includes(sprint_feedbacks: [user: :leaves]))
    end

    field :sprint, Types::SprintType, null: false do
      argument :id, ID, required: true
    end
    def sprint(id:)
      authorize Sprint.find(id), :show
    end

    field :daily_nerd_messages, Types::DailyNerdMessageType.connection_type, null: false do
      argument :user_id, ID, required: false
      argument :from_date, GraphQL::Types::ISO8601Date, required: false
      argument :to_date, GraphQL::Types::ISO8601Date, required: false
    end
    def daily_nerd_messages(user_id: nil, from_date: nil, to_date: nil)
      scope = policy_scope(DailyNerdMessage.all.includes(:user).order(created_at: :desc))
      scope = scope.where(sprint_feedback_id: User.find(user_id).sprint_feedbacks) if user_id
      scope = scope.where("created_at >= ?", from_date) if from_date
      scope = scope.where("created_at <= ?", to_date) if to_date
      scope
    end
  end
end
