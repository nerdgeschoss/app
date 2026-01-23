# frozen_string_literal: true

render "components/current_user"

field :user, value: -> { @user } do
  field :id
  field :full_name
  field :remaining_holidays, Integer, null: true, value: -> { remaining_holidays unless root { @hide_financials } }
  field :api_token, String, null: true, value: -> { api_token if root { @user } == Current.user }
end

field :salaries, array: true, value: -> { (root { @hide_financials }) ? [] : @salaries } do
  field :id
  field :hgf_hash, null: true
  field :current, Boolean, value: -> { current? }
  field :valid_from, Date
  field :brut, Float
  field :net, Float
end

field :inventories, array: true, value: -> { (root { @hide_financials }) ? [] : @inventories } do
  field :id
  field :name
  field :returned, Boolean, value: -> { returned? }
  field :received_at, Time
  field :returned_at, Time, null: true
  field :details, null: true
end

field :permit_edit_inventory, Boolean, value: -> { policy(Inventory).create? }
