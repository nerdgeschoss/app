# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :display_name, String, null: false
    field :email, String, null: false
    field :ssh_key, String
    field :remaining_holidays, Integer, null: false, required_permission: :financial_details
  end
end
