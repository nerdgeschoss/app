# frozen_string_literal: true

class Views::JobApplications::New < Views::Base
  include Phlex::Rails::Helpers::FormWith

  BENEFITS = ["remote", "schedule", "culture"].freeze
  HANDBOOK_URL = "https://nerdgeschoss.de/handbook"

  prop :job_application, JobApplication

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack(size: 24, desktop_size: 32) do
        # Logged-in visitors get the logo from the sidebar.
        render Components::Brand.new if current_user.nil?
        text(type: "h1-bold") { t(".title") }
        render(Components::SplitLayout.new(aside: -> { welcome_card })) { application_form }
      end
    end
  end

  private

  # i18n-tasks-use t('job_applications.new.benefits.remote') t('job_applications.new.benefits.schedule') t('job_applications.new.benefits.culture')
  def welcome_card
    render Components::Card.new(title: t(".welcome.title"), subtitle: -> { text { t(".welcome.text") } }) do
      stack(size: 16) do
        text(type: "h5-bold") { t(".benefits.title") }
        BENEFITS.each { |benefit| text { t(".benefits.#{benefit}") } }
        stack(size: 0) do
          text { t(".handbook") }
          a(href: HANDBOOK_URL) { HANDBOOK_URL }
        end
      end
    end
  end

  def application_form
    form_with(model: @job_application, url: job_applications_path) do |form|
      stack(size: 16) do
        render Components::Card.new do
          stack(size: 24) do
            stack(grid: "tablet") do
              form.select :job_role, enum_choices(:job_role)
              form.select :level, enum_choices(:level)
            end
            stack(grid: "tablet") do
              form.text_field :first_name
              form.text_field :last_name
            end
            stack(grid: "tablet") do
              form.email_field :email
              form.text_field :github_handle
            end
            stack(grid: "tablet") do
              form.url_field :website_url
              form.date_field :available_from
            end
            form.text_area :motivation
            form.file_field :attachments, multiple: true
          end
        end
        stack(line: "mobile", justify: "right") do
          form.submit t(".submit")
        end
      end
    end
  end

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def enum_choices(name)
    JobApplication.public_send(name.to_s.pluralize).keys.map { [t("job_application.#{name}.#{it}"), it] }
  end
end
