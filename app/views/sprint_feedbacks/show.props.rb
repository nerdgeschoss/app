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
  field :turnover_per_storypoint, Float, null: true, value: -> { turnover_per_storypoint if root(&:current_user).role?(:hr) }
  field :turnover, Float, null: true, value: -> { turnover if root(&:current_user).role?(:hr) }
  field :target_total_hours, Float
  field :target_billable_hours, Float

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
    field :email
    field :avatar_url, value: -> { avatar_image(size: 120) }
  end

  field :days, array: true do
    field :id
    field :day, Date
    field :daily_nerd_message, null: true do
      field :id
      field :message
    end
    field :leave, null: true do
      field :id
      field :type
    end
    field :time_entries, array: true do
      field :id
      field :notes, null: true
      field :type, value: -> { task }
      field :hours, Float
      field :project, null: true do
        field :id
        field :name
      end
      field :task, null: true, value: -> { task_object } do
        field :id
        field :status
        field :total_hours, Float
        field :repository
        field :github_url, null: true
        field :users, array: true do
          field :id
          field :display_name
          field :email
          field :avatar_url, value: -> { avatar_image(size: 120) }
        end
      end
    end
    field :has_time_entries, Boolean, value: -> { has_time_entries? }
    field :working_day, Boolean, value: -> { working_day? }
    field :has_daily_nerd_message, Boolean, value: -> { has_daily_nerd_message? }
    field :tracked_hours, Float
    field :billable_hours, Float
    field :target_total_hours, Float
    field :target_billable_hours, Float
  end
end
