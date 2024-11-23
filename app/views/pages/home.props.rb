field :current_user, global: :current_user do
  field :id
  field :display_name
  field :avatar_url, value: -> { avatar_image(size: 200) }
end

field :upcoming_leaves, array: true, value: -> { @upcoming_leaves } do
  field :id
  field :start_date, Date, value: -> { leave_during.min }
  field :end_date, Date, value: -> { leave_during.max }
  field :title
end

field :payslips, array: true, value: -> { @payslips } do
  field :id
  field :month, Date, value: -> { month }
end

field :remaining_holidays, value: -> { current_user.remaining_holidays }
