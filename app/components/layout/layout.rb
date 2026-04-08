# frozen_string_literal: true

class Components::Layout < Components::Base
  prop :user, _Nilable(User), default: nil
  prop :container, _Boolean, default: false

  def view_template(&block)
    div(class: "layout") do
      if @user
        div(class: "layout__sidebar") do
          render Sidebar.new(user: @user)
        end
      end
      if @container
        main(class: "layout__content") do
          render Container.new(&block)
        end
      else
        main(class: "layout__content", &block)
      end
    end
  end
end
