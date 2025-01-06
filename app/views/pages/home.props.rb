# frozen_string_literal: true

render "components/current_user"

field :upcoming_leaves, array: true, value: -> { @upcoming_leaves } do
  field :id
  field :start_date, Date, value: -> { leave_during.min }
  field :end_date, Date, value: -> { leave_during.max }
  field :title
end

field :payslips, array: true, value: -> { @payslips } do
  field :id
  field :month, Date, value: -> { month }
  field :url, value: -> { helpers.image_file_url(pdf) }
end

field :remaining_holidays, Integer, value: -> { current_user.remaining_holidays }
