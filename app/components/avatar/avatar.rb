# frozen_string_literal: true

class Components::Avatar < Components::Base
  prop :email, String
  prop :display_name, _Nilable(String)
  prop :avatar_url, _Nilable(String)
  prop :large, _Boolean, default: false

  def view_template
    div(class: ["avatar", ("avatar--large" if @large)]) do
      if @avatar_url
        img(class: "avatar__image", src: @avatar_url, alt: @display_name || @email)
      else
        div(class: "avatar__placeholder") do
          text(type: "h4-bold") { (@display_name || @email).slice(0, 2).upcase }
        end
      end
    end
  end
end
