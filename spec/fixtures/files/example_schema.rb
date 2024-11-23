field :current_user do
  field :first_name
  field :email, null: false
  field :age, Integer
end
field :sprint, null: false, value: -> { sprint2 }
