# frozen_string_literal: true

render "components/current_user"

field :payslips, array: true, value: -> { @payslips } do
  field :id
  field :user do
    field :display_name
  end
  field :month, Date, value: -> { month }
  field :url, value: -> { helpers.image_file_url(pdf) }
  field :permit_destroy, Boolean, value: -> { helpers.policy(self).destroy? }
end
field :next_page_url, value: -> { path_to_next_page @payslips }

field :permit_create_payslip, Boolean, value: -> { helpers.policy(Payslip).create? }
