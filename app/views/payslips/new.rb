# frozen_string_literal: true

class Views::Payslips::New < Components::Base
  prop :payslip, Payslip
  prop :users, _Any

  def view_template
    stack do
      form_with(model: @payslip, url: payslips_path, builder: ComponentFormBuilder, html: {multipart: true}) do |f|
        stack do
          f.select :user_id, @users.map { |u| [u.display_name, u.id] }
          f.date_field :month
          f.file_field :pdf
          f.submit "create"
        end
      end
    end
  end
end
