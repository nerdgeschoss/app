# frozen_string_literal: true

render "components/current_user"

field :date, Date, value: -> { @date }
field :feed_url, value: -> { helpers.feed_leaves_url(auth: current_user.id, format: :ics, protocol: :webcal) }

field :pending_leaves, array: true, value: -> { @pending_leaves } do
  field :id
  field :type
  field :status
  field :unicode_emoji, value: -> { Leave::Presenter.new(self).unicode_emoji }
  field :number_of_days
  field :days, array: true, value: -> { days.sort } do
    field :day, Date, value: -> { self }
  end
  field :user do
    field :id
    field :display_name
    field :avatar_url, value: -> { avatar_image(size: 200) }
    field :email
  end
  field :permit_update, Boolean, value: -> { helpers.policy(self).update? }
  field :permit_destroy, Boolean, value: -> { helpers.policy(self).destroy? }
  field :permit_approve, Boolean, value: -> { helpers.policy(self).approve? }
end

field :pending_leaves_counts, value: -> { @pending_leaves_counts } do
  field :paid, Integer, value: -> { fetch("paid", 0) }
  field :sick, Integer, value: -> { fetch("sick", 0) }
  field :non_working, Integer, value: -> { fetch("non_working", 0) }
end
field :pending_leave_type, value: -> { helpers.params.fetch(:pending_leave_type, "paid") }

field :users, array: true, value: -> { @users } do
  field :id
  field :display_name
  field :avatar_url, value: -> { avatar_image(size: 200) }
  field :email
  field :day_counts, value: -> { root { @day_counts }[__getobj__] } do
    field :paid, Integer, value: -> { fetch("paid", 0) }
    field :sick, Integer, value: -> { fetch("sick", 0) }
    field :non_working, Integer, value: -> { fetch("non_working", 0) }
  end
end

field :leaves, array: true, value: -> { @leaves } do
  field :id
  field :user_id
  field :type
  field :status
  field :unicode_emoji, value: -> { Leave::Presenter.new(self).unicode_emoji }
  field :number_of_days
  field :days, array: true, value: -> { days.sort } do
    field :day, Date, value: -> { self }
  end
end
