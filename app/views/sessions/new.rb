# frozen_string_literal: true

class Views::Sessions::New < Views::Base
  include Phlex::Rails::Helpers::FormWith

  def view_template
    render Container.new do
      stack(size: 32, align: :center) do
        render Logo.new
        render Card.new(title: "Login", type: :"login-card") do
          form_with(url: helpers.login_path, method: :post) do
            stack(size: 16) do
              render TextField.new(name: "email", label: "Email", auto_complete: "email")
              render Button.new(title: "Login")
            end
          end
        end
      end
    end
  end
end
