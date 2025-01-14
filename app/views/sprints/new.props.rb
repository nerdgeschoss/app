# frozen_string_literal: true

field :sprint, value: -> { @sprint } do
  field :sprint_from, Time
  field :sprint_until, Time
  field :working_days, Integer
end
