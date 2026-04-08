# frozen_string_literal: true

module Types
  class TaskStatusEnum < Types::BaseEnum
    description "GitHub project board status columns for tasks."

    value "TODO", value: "Todo"
    value "IDEA", value: "Idea"
    value "SHAPING", value: "Shaping"
    value "IN_PROGRESS", value: "In Progress"
    value "REVIEW", value: "Review"
    value "PENDING_RELEASE", value: "Pending Release"
    value "DONE", value: "Done"
  end
end
