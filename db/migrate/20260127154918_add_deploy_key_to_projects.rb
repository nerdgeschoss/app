# frozen_string_literal: true

class AddDeployKeyToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :deploy_key, :string
  end
end
