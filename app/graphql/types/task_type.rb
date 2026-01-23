# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :issue_number, Integer, null: false
    field :title, String, null: false
    field :status, String, null: false
    field :labels, [String], null: false
    field :repository, String, null: false
    field :story_points, Integer, null: true
    field :sprint, Types::SprintType, null: true
  end
end
