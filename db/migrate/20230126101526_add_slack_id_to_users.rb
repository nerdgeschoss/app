class AddSlackAddressToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :slack_id, :string
  end
end
