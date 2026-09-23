# frozen_string_literal: true

class Components::JobApplicationCard < Components::Base
  prop :job_application, JobApplication

  def view_template
    render Components::Card.new(
      href: job_application_path(@job_application),
      title: @job_application.full_name,
      subtitle: -> { subtitle },
      context: -> { text(type: "caption-secondary-regular") { l(@job_application.created_at, format: :short) } }
    )
  end

  private

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  # i18n-tasks-use t('job_application.status.craft_interview') t('job_application.status.hired') t('job_application.status.interview') t('job_application.status.job_offer') t('job_application.status.rejected') t('job_application.status.review')
  def subtitle
    stack(line: "mobile", size: 4, align: "center") do
      plain t(".role_and_level",
        level: t("job_application.level.#{@job_application.level}"),
        role: t("job_application.job_role.#{@job_application.job_role}"))
      render(Components::Pill.new) { t("job_application.status.#{@job_application.status}") }
    end
  end
end
