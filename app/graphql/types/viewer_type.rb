# frozen_string_literal: true

module Types
  class ViewerType < Types::BaseObject
    field :id, ID, null: false
    field :display_name, String, null: false
    field :email, String, null: false
  end
end
