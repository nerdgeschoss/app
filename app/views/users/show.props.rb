# frozen_string_literal: true

render "components/current_user"

field :user, value: -> { @user } do
  field :id
  field :full_name
  field :remaining_holidays, Integer
end

field :salaries, array: true, value: -> { @salaries } do
  field :id
  field :hgf_hash, null: true
  field :current, Boolean, value: -> { current? }
  field :valid_from, Date
  field :brut, Float
  field :net, Float
end

field :inventories, array: true, value: -> { @inventories } do
  field :id
  field :name
  field :returned, Boolean, value: -> { returned? }
  field :received_at, Time
  field :returned_at, Time, null: true
  field :details, null: true
end

field :permit_edit_inventory, Boolean, value: -> { policy(Inventory).create? }
