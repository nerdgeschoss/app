# frozen_string_literal: true

render "components/current_user"

field :sprints, array: true, value: -> { @sprints } do
  field :id
  field :title
  field :sprint_from, Time
  field :sprint_until, Time
  field :finished_storypoints, Integer
  field :finished_storypoints_per_day, Float
  field :average_rating, Float
  field :total_working_days, Integer
  field :turnover_per_storypoint, Float, null: true, value: -> { turnover_per_storypoint if root(&:current_user).role?(:hr) }
  field :turnover, Float, null: true, value: -> { turnover if root(&:current_user).role?(:hr) }

  field :performances, array: true, value: -> { sprint_feedbacks.select { helpers.policy(_1).show? }.sort_by { _1.user.display_name } } do
    field :id
    field :working_day_count, Integer
    field :tracked_hours, Float
    field :billable_hours, Float
    field :retro_rating, Integer, null: true
    field :finished_storypoints, Integer
    field :target_total_hours, Float
    field :target_billable_hours, Float
    field :days, array: true do
      field :id
      field :day, Date
      field :working_day, Boolean, value: -> { working_day? }
      field :has_daily_nerd_message, Boolean, value: -> { has_daily_nerd_message? }
      field :leave, null: true do
        field :id
        field :type
      end
      field :has_time_entries, Boolean, value: -> { has_time_entries? }
    end

    field :user do
      field :id
      field :display_name
      field :avatar_url, value: -> { avatar_image(size: 120) }
    end
  end
end
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @sprints }
field :permit_create_sprint, Boolean, value: -> { helpers.policy(Sprint).create? }
