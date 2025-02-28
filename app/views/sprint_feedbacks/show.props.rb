# frozen_string_literal: true

render "components/current_user"

field :feedback, value: -> { @feedback } do
  field :id
  field :finished_storypoints, Integer
  field :finished_storypoints_per_day, Float
  field :retro_rating, Integer, null: true
  field :retro_text, null: true
  field :working_day_count, Integer
  field :tracked_hours, Float
  field :billable_hours, Float

  field :permit_edit_retro_notes, Boolean, value: -> { helpers.policy(self).update? }

  field :sprint do
    field :id
    field :title
    field :sprint_from, Date
    field :sprint_until, Date
  end

  field :user do
    field :id
    field :display_name
    field :avatar_url, value: -> { avatar_image(size: 120) }
  end

  field :days, array: true, value: -> { sprint.days.map { {day: _1, feedback: self} } } do
    field :id, value: -> { [self[:feedback].id, self[:day].to_s].join("-") }
    field :day, Date, value: -> { self[:day] }
    field :daily_nerd_message, null: true, value: -> { self[:feedback].daily_nerd_messages.find { _1.created_at.to_date == self[:day] } } do
      field :id
      field :message
    end
    field :leave, null: true, value: -> { self[:feedback].leaves.find { _1.days.include?(self[:day]) } } do
      field :id
      field :type
    end
    field :time_entries, array: true, value: -> {
      self[:feedback].sprint.time_entries.filter { _1.created_at.to_date == self[:day] && _1.user_id == self[:feedback].user_id }
    } do
      field :id
      field :notes, null: true
      field :type, value: -> { task }
      field :hours
      field :project, null: true do
        field :id
        field :name
      end
      field :task, null: true, value: -> { task_object } do
        field :id
        field :status
        field :total_hours
      end
    end
  end
end
