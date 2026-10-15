# frozen_string_literal: true

render "components/owning_user"

field :berlin_holidays, array: true, value: -> { BerlinHolidays.upcoming_holidays } do
  field :name
  field :date, Date
end
