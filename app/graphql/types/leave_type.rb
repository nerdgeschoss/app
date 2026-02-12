# frozen_string_literal: true

module Types
  class LeaveType < Types::BaseObject
    description "A leave request tracking specific days off and their approval status."

    field :id, ID, null: false, description: "UUID."
    field :user, Types::UserType, null: false, description: "The employee who requested the leave."
    field :title, String, null: false, description: "Reason provided by the employee (e.g. 'Family vacation')."
    field :days, [GraphQL::Types::ISO8601Date], null: false,
      description: "Calendar dates covered by this leave. May be non-contiguous."
    field :status, String, null: false,
      description: "One of: 'pending_approval', 'approved', 'rejected'."
    field :type, String, null: false,
      description: "One of: 'paid' (deducts from holiday allowance), 'unpaid', 'sick', 'non_working'."
  end
end
