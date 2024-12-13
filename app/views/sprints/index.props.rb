render "components/current_user"

field :sprints, array: true, value: -> { @sprints } do
  field :id
  field :title
  field :sprint_from, Time
  field :sprint_until, Time

  field :performances, array: true, value: -> { sprint_feedbacks.select { helpers.policy(_1).show? }.sort_by { _1.user.display_name } } do
    field :id
    field :working_day_count, Integer
    field :tracked_hours, Float
    field :billable_hours, Float
    field :retro_rating, Integer, null: true
    field :finished_storypoints, Integer
    field :days, array: true, value: -> { sprint.days.map { {day: _1, feedback: self} } } do
      field :id, value: -> { [self[:feedback].id, self[:day].to_s].join("-") }
      field :day, Date, value: -> { self[:day] }
      field :has_daily_nerd_message, Boolean, value: -> { !!self[:feedback].daily_nerd_messages.find { _1.created_at.to_date == self[:day] } }
      field :leave, null: true, value: -> { self[:feedback].leaves.find { _1.days.include?(self[:day]) } } do
        field :id
        field :type
      end
      field :has_time_entries, Boolean, value: -> {
        self[:feedback].sprint.time_entries.any? { _1.created_at.to_date == self[:day] && _1.user_id == self[:feedback].user_id }
      }
    end

    field :user do
      field :id
      field :display_name
      field :avatar_url, value: -> { avatar_image(size: 120) }
    end
  end
end
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @sprints }
