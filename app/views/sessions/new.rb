# frozen_string_literal: true

class Views::Sessions::New < Views::Base
  prop :login, Login

  def view_template
    render Container.new do
      stack(size: 32, align: :center) do
        render Logo.new
        render Card.new(title: "Login", type: :"login-card") do
          form_with(model: @login, url: login_path, builder: ComponentFormBuilder) do |f|
            stack(size: 16) do
              f.text_field :email, autocomplete: "email"
              f.submit "Login"
            end
          end
        end
      end
    end
  end
end
