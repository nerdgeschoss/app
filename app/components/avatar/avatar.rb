# frozen_string_literal: true

class Components::Avatar < Components::Base
  prop :display_name, _Nilable(String), default: nil
  prop :avatar_url, _Nilable(String), default: nil
  prop :email, String
  prop :large, _Boolean, default: false

  def view_template
    div(class: css_classes) do
      if @avatar_url
        img(class: "avatar__image", src: @avatar_url, alt: @display_name || @email)
      else
        div(class: "avatar__placeholder") do
          text(type: :"h4-bold") { initials }
        end
      end
    end
  end

  private

  def css_classes
    classes = ["avatar"]
    classes << "avatar--large" if @large
    classes.join(" ")
  end

  def initials
    source = @display_name.presence || @email
    source.slice(0, 2).upcase
  end
end
