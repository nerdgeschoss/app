# frozen_string_literal: true

class ChangeFieldToCitext < ActiveRecord::Migration[6.0]
  def up
    enable_extension "citext"
    change_column :tasks, :status, :citext
  end

  def down
    change_column :tasks, :status, :string
    disable_extension "citext"
  end
end
