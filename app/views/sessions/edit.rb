# frozen_string_literal: true

class Views::Sessions::Edit < Views::Base
  include Phlex::Rails::Helpers::FormWith

  prop :login, Login

  def view_template
    render Container.new do
      stack(size: 32, align: :center) do
        render Logo.new
        render Card.new(title: "Login", type: :"login-card") do
          form_with(model: @login, url: helpers.confirm_login_path) do |f|
            stack(size: 16) do
              render TextField.new(name: "login[email]", label: "Email", value: @login.email, disabled: true)
              render TextField.new(name: "login[code]", label: "Code", auto_complete: "one-time-code", errors: @login.errors.full_messages_for(:code))
              render Button.new(title: "Login")
            end
          end
        end
      end
    end
  end
end
