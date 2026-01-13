# frozen_string_literal: true

render "components/current_user"

field :filter, value: -> { @filter }
field :users, array: true, value: -> { @users } do
  field :id
  field :avatar_url, value: -> { avatar_image(size: 80) }
  field :full_name
  field :nick_name, null: true
  field :remaining_holidays, Integer, null: true, value: -> { remaining_holidays unless root { @hide_financials } }
  field :teams, String, array: true, value: -> { team_member_of }
  field :current_salary, null: true, value: -> { current_salary unless root { @hide_financials } } do
    field :brut, Float
    field :valid_from, Date
  end
end
