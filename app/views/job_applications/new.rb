# frozen_string_literal: true

class Views::JobApplications::New < Views::Base
  include Phlex::Rails::Helpers::FormWith

  prop :job_application, JobApplication

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack do
        text(type: "h1-bold") { t(".title") }
        render Components::Card.new do
          form_with(model: @job_application, url: job_applications_path) do |form|
            stack(size: 16) do
              form.select :job_role, enum_choices(:job_role)
              form.select :level, enum_choices(:level)
              form.text_field :first_name
              form.text_field :last_name
              form.email_field :email
              form.text_field :github_handle
              form.url_field :website_url
              form.date_field :available_from
              form.text_area :motivation
              form.file_field :attachments, multiple: true
              form.submit t(".submit")
            end
          end
        end
      end
    end
  end

  private

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def enum_choices(name)
    JobApplication.public_send(name.to_s.pluralize).keys.map { [t("job_application.#{name}.#{it}"), it] }
  end
end
