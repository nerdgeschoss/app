# frozen_string_literal: true

render "components/current_user"

field :permit_user_select, Boolean, value: -> { helpers.policy(Leave).show_all_users? }
field :users, array: true, value: -> { User.currently_employed } do
  field :id
  field :display_name
end
field :berlin_holidays, array: true, value: -> { BerlinHolidays.upcoming_holidays } do
  field :name
  field :date, Date
end
