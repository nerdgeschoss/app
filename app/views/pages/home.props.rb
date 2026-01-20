# frozen_string_literal: true

render "components/current_user"

field :upcoming_leaves, array: true, value: -> { @upcoming_leaves } do
  field :id
  field :start_date, Date, value: -> { leave_during.min }
  field :end_date, Date, value: -> { leave_during.max }
  field :title
  field :days, array: true, value: -> { days.sort } do
    field :day, Date, value: -> { self }
  end
end

field :payslips, array: true, value: -> { @payslips } do
  field :id
  field :month, Date, value: -> { month }
  field :url, value: -> { helpers.image_file_url(pdf) }
end

field :remaining_holidays, Integer, value: -> { current_user.remaining_holidays }

field :daily_nerd_message, null: true, value: -> { @daily_nerd_message } do
  field :id, null: true
  field :message, null: true
end

field :needs_retro_for, null: true, value: -> { @needs_retro_for } do
  field :id
  field :title, value: -> { sprint.title }
end
