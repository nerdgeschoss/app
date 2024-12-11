field :users, array: true, value: -> { User.currently_employed.alphabetically } do
  field :id
  field :display_name
end
field :default_month, Time, value: -> { DateTime.current.beginning_of_month }
