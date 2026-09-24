# frozen_string_literal: true

class Components::JobApplicationCard < Components::Base
  prop :job_application, JobApplication

  def view_template
    render Components::Card.new(href: job_application_path(@job_application), subtitle: -> { header }, with_divider: true) do
      stack(size: 8) do
        row(t(".application_date"), l(@job_application.created_at, format: :long))
        row(t(".role_and_level_label"), t(".role_and_level",
          level: t("job_application.level.#{@job_application.level}"),
          role: t("job_application.job_role.#{@job_application.job_role}")))
      end
    end
  end

  private

  # i18n-tasks-use t('job_application.status.craft_interview') t('job_application.status.hired') t('job_application.status.interview') t('job_application.status.job_offer') t('job_application.status.rejected') t('job_application.status.review')
  def header
    stack(line: "mobile", size: 16, justify: "space-between", align: "top") do
      text(type: "h5-bold") { @job_application.full_name }
      text(color: @job_application.rejected? ? "text-warning" : nil, no_wrap: true) { t("job_application.status.#{@job_application.status}") }
    end
  end

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def row(label, value)
    stack(line: "mobile", size: 8, justify: "space-between", align: "center") do
      text(type: "caption-primary-regular", color: "label-heading-secondary", no_wrap: true) { label }
      text(type: "caption-primary-regular", align: "right") { value }
    end
  end
end
