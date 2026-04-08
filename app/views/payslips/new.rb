# frozen_string_literal: true

class Views::Payslips::New < Components::Base
  prop :payslip, Payslip
  prop :users, _Any

  def view_template
    stack do
      simple_form_for(@payslip, url: payslips_path, html: {multipart: true}) do |f|
        stack do
          f.input :user_id, as: :select, collection: @users.map { |u| [u.display_name, u.id] }
          f.input :month, as: :date
          f.input :pdf, as: :file
          f.submit "create"
        end
      end
    end
  end

  private

  def simple_form_for(model, **options, &block)
    options[:builder] ||= ComponentFormBuilder
    output = view_context.simple_form_for(model, **options) { |builder|
      yield Phlex::Rails::Builder.new(builder, component: self)
    }
    raw(output)
  end
end
