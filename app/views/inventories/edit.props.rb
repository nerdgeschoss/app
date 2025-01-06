# frozen_string_literal: true

field :inventory, value: -> { @inventory } do
  field :id
  field :name
  field :details, null: true
  field :received_at, Time
  field :returned_at, Time, null: true
end
