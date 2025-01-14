# frozen_string_literal: true

render "components/current_user"

field :feedback, value: -> { @feedback } do
  field :id
  field :retro_rating, Integer, null: true
  field :retro_text, null: true
  field :skip_retro, Boolean
end
