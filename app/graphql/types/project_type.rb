# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :archived, Boolean, null: false
    field :client_name, String, null: false
    field :name, String, null: false
    field :repository, String, null: true
    field :deploy_key, String, null: true
  end
end
