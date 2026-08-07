# frozen_string_literal: true

class Components::Layout < Components::Base
  prop :user, _Nilable(User)
  prop :container, _Boolean, default: false

  def view_template(&block)
    div(class: "layout") do
      if @user
        div(class: "layout__sidebar") { render Components::Sidebar.new(user: @user) }
      end
      main(class: "layout__content") do
        if @container
          render Components::Container.new, &block
        else
          yield
        end
      end
    end
  end
end
