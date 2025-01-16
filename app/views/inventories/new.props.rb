# frozen_string_literal: true

field :user, value: -> { @inventory.user } do
  field :id
end
