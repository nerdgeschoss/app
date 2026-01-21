# frozen_string_literal: true

render "components/current_user"

field :feed_url, value: -> { helpers.feed_leaves_url(auth: current_user.id, format: :ics, protocol: :webcal) }
field :active_filter, value: -> { @status }
field :permit_user_select, Boolean, value: -> { helpers.policy(Leave).show_all_users? }
field :users, array: true, value: -> { User.currently_employed } do
  field :id
  field :display_name
end
field :leaves, array: true, value: -> { @leaves } do
  field :id
  field :unicode_emoji, value: -> { Leave::Presenter.new(self).unicode_emoji }
  field :title
  field :status
  field :days, array: true, value: -> { days.sort } do
    field :day, Date, value: -> { self }
  end
  field :number_of_days
  field :user do
    field :id
    field :display_name
  end
  field :permit_update, Boolean, value: -> { helpers.policy(self).update? }
  field :permit_destroy, Boolean, value: -> { helpers.policy(self).destroy? }
  field :permit_approve, Boolean, value: -> { helpers.policy(self).approve? }
end
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @leaves }
