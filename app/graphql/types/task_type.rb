# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    description "A GitHub issue synced from the sprint project board."

    field :id, ID, null: false, description: "Internal UUID. For GitHub identifier, use repository + issue_number."
    field :issue_number, Integer, null: false, description: "GitHub issue number within its repository."
    field :title, String, null: false, description: "Issue title from GitHub."
    field :description, String, null: true, description: "Issue body from GitHub. Null if empty."
    field :status, String, null: false, description: "Board column (e.g. 'Todo', 'In Progress', 'Done')."
    field :labels, [String], null: false, description: "GitHub labels (e.g. ['frontend', 'bug'])."
    field :repository, String, null: false, description: "GitHub repository in 'owner/repo' format."
    field :story_points, Integer, null: true, description: "Estimated effort. Null if no estimate set."
    field :sprint, Types::SprintType, null: true, description: "Assigned sprint. Null for unscheduled backlog items."
    field :time_entries, Types::TimeEntryType.connection_type, null: false, description: "Time entries logged against this task."
    field :users, Types::UserType.connection_type, null: false, description: "Team members assigned to this task."
    field :project, Types::ProjectType, null: true, description: "Project this task belongs to. Null if unlinked."
  end
end
