field :current_user, global: :current_user do
  field :id
  field :display_name
  field :avatar_url, value: -> { avatar_image(size: 200) }
end
