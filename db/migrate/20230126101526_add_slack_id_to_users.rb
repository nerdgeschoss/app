# frozen_string_literal: true

class AddSlackIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :slack_id, :string
  end
end
