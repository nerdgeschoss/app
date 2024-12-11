render "components/current_user"

field :feed_url, value: -> { helpers.feed_leaves_url(auth: current_user.id, format: :ics, protocol: :webcal) }
field :filters, array: true, value: -> { Leave.statuses.keys + ["all"] } do
  field :id, value: -> { self }
end
field :active_filter, value: -> { @status }
field :permit_user_select, value: -> { helpers.policy(Leave).show_all_users? }
field :users, array: true, value: -> { User.currently_employed } do
  field :id
  field :display_name
end
field :leaves, array: true, value: -> { @leaves } do
  field :id
  field :unicode_emoji, value: -> { Leave::Presenter.new(self).unicode_emoji }
  field :title
  field :days, array: true
  field :user do
    field :id
    field :display_name
  end
  field :permit_update, value: -> { helpers.policy(self).update? }
  field :permit_destroy, value: -> { helpers.policy(self).destroy? }
end
