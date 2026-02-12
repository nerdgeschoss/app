# frozen_string_literal: true

module Types
  class ViewerType < Types::BaseObject
    description "Minimal profile of the authenticated user. Use UserType for full details."

    field :id, ID, null: false, description: "UUID."
    field :display_name, String, null: false, description: "Nickname, first name, or email (first available)."
    field :email, String, null: false, description: "Primary email used for login and Gravatar."
  end
end
