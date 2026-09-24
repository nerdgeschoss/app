# frozen_string_literal: true

class Views::JobApplications::Show < Views::Base
  include Phlex::Rails::Helpers::FormWith

  prop :job_application, JobApplication

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack do
        text(type: "h1-bold") { t(".title") }
        hr_actions
        status_card
        booking_card
        details_card
      end
    end
  end

  private

  def hr_actions
    job_application_policy = policy(@job_application)
    return unless job_application_policy.invite? || job_application_policy.reject? || job_application_policy.hire? || job_application_policy.mark_hired?

    stack(line: "mobile") do
      render(Components::Button.new(modal_url: new_job_application_rejection_path(@job_application))) { t(".reject") } if job_application_policy.reject?
      # i18n-tasks-use t('job_applications.show.invite.interview') t('job_applications.show.invite.craft_interview')
      render(Components::Button.new(modal_url: new_job_application_invitation_path(@job_application))) { t(".invite.#{JobApplication::Invitation.new(job_application: @job_application).stage}") } if job_application_policy.invite?
      render(Components::Button.new(modal_url: new_job_application_offer_path(@job_application))) { t(".hire") } if job_application_policy.hire?
      if job_application_policy.mark_hired?
        form_with(url: job_application_hiring_path(@job_application), data: {turbo_confirm: t(".mark_hired_confirm", name: @job_application.full_name)}) do |form|
          form.submit t(".mark_hired")
        end
      end
    end
  end

  # i18n-tasks-use t('job_applications.show.status.review.title') t('job_applications.show.status.review.text')
  # i18n-tasks-use t('job_applications.show.status.interview.title') t('job_applications.show.status.interview.text')
  # i18n-tasks-use t('job_applications.show.status.interview_booked.title') t('job_applications.show.status.interview_booked.text')
  # i18n-tasks-use t('job_applications.show.status.craft_interview.title') t('job_applications.show.status.craft_interview.text')
  # i18n-tasks-use t('job_applications.show.status.craft_interview_booked.title') t('job_applications.show.status.craft_interview_booked.text')
  # i18n-tasks-use t('job_applications.show.status.job_offer.title') t('job_applications.show.status.job_offer.text')
  # i18n-tasks-use t('job_applications.show.status.rejected.title') t('job_applications.show.status.rejected.text')
  # i18n-tasks-use t('job_applications.show.status.hired.title') t('job_applications.show.status.hired.text')
  def status_card
    render Components::Card.new(
      title: t(".status.#{status_key}.title", name: @job_application.first_name),
      subtitle: -> { text { t(".status.#{status_key}.text", level: level_label(@job_application.offered_level || @job_application.level), role: role_label) } },
      with_divider: true
    ) do
      stack do
        if booking.booked?
          stack(line: "mobile", justify: "space-between", align: "center") do
            text { t(".booked") }
            form_with(url: job_application_booking_path(@job_application), method: :delete) { |form| form.submit t(".update") }
          end
        end
        stack(line: "mobile", justify: "space-between") do
          text(type: "body-bold") { l(@job_application.created_at, format: :long) }
          text { t(".submitted") }
        end
      end
    end
  end

  def booking_card
    return if booking.stage.nil? || booking.booked?

    render Components::Card.new do
      render Components::CalendlyWidget.new(url: booking.scheduling_url, booking_url: job_application_booking_path(@job_application),
        name: @job_application.full_name, email: @job_application.email)
    end
  end

  def details_card
    render Components::Card.new do
      stack(size: 16) do
        detail :job_role, role_label
        detail :level, level_label(@job_application.level)
        detail :first_name, @job_application.first_name
        detail :last_name, @job_application.last_name
        detail :email, @job_application.email
        detail :github_handle, @job_application.github_handle, href: "https://github.com/#{@job_application.github_handle.delete_prefix("@")}" if @job_application.github_handle.present?
        detail :website_url, @job_application.website_url, href: @job_application.website_url if @job_application.website_url.present?
        detail :available_from, l(@job_application.available_from) if @job_application.available_from
        detail :motivation, @job_application.motivation
        render Components::Field.new(label: JobApplication.human_attribute_name(:attachments)) do
          @job_application.attachments.each do |attachment|
            render Components::FieldValue.new(value: attachment.filename.to_s, href: image_file_path(attachment))
          end
        end
      end
    end
  end

  def detail(attribute, value, href: nil)
    render Components::Field.new(label: JobApplication.human_attribute_name(attribute)) do
      render Components::FieldValue.new(value:, href:)
    end
  end

  def status_key
    booking.booked? ? "#{booking.stage}_booked" : @job_application.status
  end

  def booking
    @booking ||= JobApplication::Booking.new(@job_application)
  end

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  def role_label
    t("job_application.job_role.#{@job_application.job_role}")
  end

  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def level_label(level)
    t("job_application.level.#{level}")
  end
end
