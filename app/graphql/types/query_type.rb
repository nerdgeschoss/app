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

    field :projects, Types::ProjectType.connection_type, null: false,
      description: "Paginated list of projects. Results are scoped by the caller's role." do
      argument :status, Types::ProjectStatusEnum, required: false,
        description: "Filter by lifecycle state: ACTIVE or ARCHIVED."
      argument :category, Types::ProjectCategoryEnum, required: false,
        description: "Filter by ownership: INTERNAL or CUSTOMERS."
      argument :search, String, required: false,
        description: "Case-insensitive substring match on the project name or client name."
    end
    def projects(status: nil, category: nil, search: nil)
      scope = policy_scope(Project.all)
      scope = scope.public_send(status) if status.present?
      scope = scope.public_send(category) if category.present?
      scope = scope.search(search) if search.present?
      scope
    end

    field :project, Types::ProjectType, null: false,
      description: "Look up a project by repository name or ID." do
      argument :id, ID, required: true,
        description: "Repository identifier (e.g. 'nerdgeschoss/app') or UUID. Tries repository match first, falls back to ID."
    end
    def project(id:)
      project = Project.find_by(repository: id) || Project.find(id)
      authorize project, :show
    end

    field :sprints, Types::SprintType.connection_type, null: false,
      description: "All sprints in reverse chronological order. Eager-loads feedback and leave data."
    def sprints
      policy_scope(Sprint.all.reverse_chronologic.includes(sprint_feedbacks: [user: :leaves]))
    end

    field :sprint, Types::SprintType, null: false,
      description: "Look up a single sprint by ID." do
      argument :id, ID, required: true, description: "UUID of the sprint."
    end
    def sprint(id:)
      authorize Sprint.find(id), :show
    end

    field :tasks, Types::TaskType.connection_type, null: false,
      description: "GitHub tasks from the sprint project board. Supports filtering by sprint, text search, and GitHub reference." do
      argument :sprint_id, ID, required: false,
        description: "Filter to tasks in this sprint. Omit to return tasks across all sprints."
      argument :search, String, required: false,
        description: "Case-insensitive substring match on the task title."
      argument :github, String, required: false,
        description: "GitHub reference in 'repository#number' format (e.g. 'nerdgeschoss/app#42'). Filters to exact match."
      argument :status, Types::TaskStatusEnum, required: false,
        description: "Filter to tasks in a specific board column."
    end
    def tasks(sprint_id: nil, search: nil, github: nil, status: nil)
      scope = policy_scope(Task.all).github(github)
      scope = scope.where(sprint_id:) if sprint_id
      scope = scope.where("title ILIKE ?", "%#{search}%") if search.present?
      scope = scope.where(status:) if status.present?
      scope
    end

    field :time_entries, Types::TimeEntryType.connection_type, null: false,
      description: "Time entries from Harvest. Supports filtering by user, project, task, and date range." do
      argument :user_id, ID, required: false,
        description: "Filter to entries logged by a specific user."
      argument :project_id, ID, required: false,
        description: "Filter to entries for a specific project."
      argument :task_id, ID, required: false,
        description: "Filter to entries linked to a specific task."
      argument :from_date, GraphQL::Types::ISO8601DateTime, required: false,
        description: "Inclusive lower bound. Only entries created on or after this datetime."
      argument :to_date, GraphQL::Types::ISO8601DateTime, required: false,
        description: "Inclusive upper bound. Only entries created on or before this datetime."
    end
    def time_entries(user_id: nil, project_id: nil, task_id: nil, from_date: nil, to_date: nil)
      scope = policy_scope(TimeEntry.all)
      scope = scope.where(user_id:) if user_id
      scope = scope.where(project_id:) if project_id
      scope = scope.where(task_id:) if task_id
      scope = scope.where(created_at: from_date..) if from_date
      scope = scope.where(created_at: ..to_date) if to_date
      scope
    end

    field :invoices, Types::InvoiceType.connection_type, null: false,
      description: "All invoices. Supports filtering by payment state." do
      argument :paid, Boolean, required: false,
        description: "Filter by payment state. Omit to return all invoices regardless of state."
    end
    def invoices(paid: nil)
      scope = policy_scope(Invoice.all)
      scope = scope.where(state: "paid") if paid == true
      scope = scope.where.not(state: "paid") if paid == false
      scope
    end

    field :daily_nerd_messages, Types::DailyNerdMessageType.connection_type, null: false,
      description: "Daily standup ('daily nerd') messages, ordered newest first." do
      argument :user_id, ID, required: false,
        description: "Filter to messages from a specific user."
      argument :from_date, GraphQL::Types::ISO8601Date, required: false,
        description: "Inclusive lower bound. Only messages created on or after this date."
      argument :to_date, GraphQL::Types::ISO8601Date, required: false,
        description: "Inclusive upper bound. Only messages created on or before this date."
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
