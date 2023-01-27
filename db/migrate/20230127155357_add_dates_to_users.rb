class AddDatesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :born_on, :date
    add_column :users, :hired_on, :date
  end
end
