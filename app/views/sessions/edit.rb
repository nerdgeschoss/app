# frozen_string_literal: true

class Views::Sessions::Edit < Views::Base
  prop :login, Login

  def view_template
    render Container.new do
      stack(size: 32, align: :center) do
        render Logo.new
        render Card.new(title: "Login", type: :"login-card") do
          simple_form_for(@login, url: confirm_login_path) do |f|
            stack(size: 16) do
              f.input :email, disabled: true
              f.input :code, autocomplete: "one-time-code"
              f.submit "Login"
            end
          end
        end
      end
    end
  end
end
