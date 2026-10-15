# frozen_string_literal: true

field :user, value: -> { @user } do
  field :id
  field :display_name
  field :avatar_url, value: -> { avatar_image(size: 200) }
  field :email
  field :roles, array: true
end
