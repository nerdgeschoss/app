# frozen_string_literal: true

field :leave, value: -> { @leave } do
  field :id
  field :title
  field :type
  field :days, array: true, value: -> { days.sort } do
    field :day, Date, value: -> { self }
  end
end
field :berlin_holidays, array: true, value: -> { BerlinHolidays.upcoming_holidays } do
  field :name
  field :date, Date
end
