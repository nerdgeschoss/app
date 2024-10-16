class AddPtoAmountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :yearly_holidays, :integer, null: false, default: 30
  end
end
