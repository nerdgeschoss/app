render "components/current_user"

field :sprints, array: true, value: -> { @sprints } do
  field :id
  field :title
  field :sprint_from, Time
  field :sprint_until, Time

  field :performances, array: true, value: -> { sprint_feedbacks } do
    field :id
    field :review_notes, null: true
    field :working_day_count, Integer
    field :holiday_count, Integer
    field :sick_day_count, Integer
    field :daily_nerd_count, Integer, value: -> { daily_nerd_count.to_i }
    field :tracked_hours, Float
    field :billable_hours, Float
    field :billable_per_day, Float
    field :retro_rating, Integer, null: true
    field :finished_storypoints, Integer
    field :revenue, Float, null: true, value: -> { revenue if helpers.policy(sprint).show_revenue? }

    field :user do
      field :id
      field :display_name
    end
  end
end
field :next_page_url, null: true, value: -> { helpers.path_to_next_page @sprints }
