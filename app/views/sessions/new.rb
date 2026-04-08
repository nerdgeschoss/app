# frozen_string_literal: true

class Views::Sessions::New < Views::Base
  prop :login, Login

  def view_template
    render Container.new do
      stack(size: 32, align: :center) do
        render Logo.new
        render Card.new(title: "Login", type: :"login-card") do
          simple_form_for(@login, url: login_path) do |f|
            stack(size: 16) do
              f.input :email, autocomplete: "email"
              f.submit "Login"
            end
          end
        end
      end
    end
  end
end
