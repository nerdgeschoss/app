# frozen_string_literal: true

class Views::JobApplications::Show < Views::Base
  include Phlex::Rails::Helpers::FormWith

  STEPS = ["apply", "review", "interview", "craft_interview", "job_offer"].freeze

  prop :job_application, JobApplication

  def view_template
    refresh_by_morphing
    render Components::Layout.new(user: current_user, container: true) do
      turbo_stream_from @job_application
      stack(size: 24, desktop_size: 32) do
        header
        render Components::SplitLayout.new(aside: -> { aside }) do
          booking_card
          details_card
        end
      end
    end
  end

  private

  def aside
    status_card
    if policy(@job_application).comment?
      render Components::JobApplicationUpdates.new(job_application: @job_application, comment: JobApplication::Comment.new(job_application: @job_application))
    end
  end

  # i18n-tasks-use t('job_applications.show.titles.review') t('job_applications.show.titles.interview') t('job_applications.show.titles.interview_booked')
  # i18n-tasks-use t('job_applications.show.titles.craft_interview') t('job_applications.show.titles.craft_interview_booked') t('job_applications.show.titles.job_offer')
  # i18n-tasks-use t('job_applications.show.titles.rejected') t('job_applications.show.titles.hired')
  def header
    stack(line: "tablet", justify: "space-between", align: "center") do
      # Logged-in visitors get the logo from the sidebar.
      render Components::Brand.new if current_user.nil?
      progress
    end
    stack(line: "tablet", justify: "space-between", align: "center") do
      text(type: "h1-bold") { t(".titles.#{status_key}") }
      hr_actions
    end
  end

  # i18n-tasks-use t('job_application.status.rejected') t('job_application.status.hired')
  def progress
    if STEPS.include?(@job_application.status)
      stepper
    else
      render(Components::Pill.new(active: true)) { t("job_application.status.#{@job_application.status}") }
    end
  end

  # i18n-tasks-use t('job_applications.show.steps.apply') t('job_applications.show.steps.review') t('job_applications.show.steps.interview')
  # i18n-tasks-use t('job_applications.show.steps.craft_interview') t('job_applications.show.steps.job_offer')
  def stepper
    reached = STEPS.index(@job_application.status)
    stack(line: "mobile", size: 8, align: "center", wrap: true, full_width: "none") do
      STEPS.each_with_index do |step, index|
        text(type: "caption-primary-regular", color: "label-body-secondary") { "—" } if index.positive?
        text(type: (index <= reached) ? "caption-primary-bold" : "caption-primary-regular",
          color: (index <= reached) ? "label-body-primary" : "label-body-secondary", uppercase: true) { t(".steps.#{step}") }
      end
    end
  end

  def hr_actions
    job_application_policy = policy(@job_application)
    return unless job_application_policy.invite? || job_application_policy.reject? || job_application_policy.hire? || job_application_policy.mark_hired?

    stack(line: "mobile", full_width: "none") do
      render(Components::Button.new(modal_url: new_job_application_rejection_path(@job_application), variant: "danger")) { t(".reject") } if job_application_policy.reject?
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
      stack(size: 24) do
        stack(grid: "tablet") do
          detail :job_role, role_label
          detail :level, level_label(@job_application.level)
        end
        stack(grid: "tablet") do
          detail :first_name, @job_application.first_name
          detail :last_name, @job_application.last_name
        end
        stack(grid: "tablet") do
          detail :email, @job_application.email
          detail :github_handle, @job_application.github_handle, href: github_url
        end
        stack(grid: "tablet") do
          detail :website_url, @job_application.website_url, href: @job_application.website_url.presence, label: t(".labels.website_url")
          detail :available_from, @job_application.available_from && l(@job_application.available_from), label: t(".labels.available_from")
        end
        detail :motivation, @job_application.motivation
        render Components::Field.new(label: JobApplication.human_attribute_name(:attachments)) do
          stack(size: 12) do
            @job_application.attachments.each do |attachment|
              render Components::FieldValue.new(value: attachment.filename.to_s, href: image_file_path(attachment))
            end
          end
        end
      end
    end
  end

  def detail(attribute, value, href: nil, label: JobApplication.human_attribute_name(attribute))
    render Components::Field.new(label:) do
      render Components::FieldValue.new(value:, href:)
    end
  end

  def github_url
    "https://github.com/#{@job_application.github_handle.delete_prefix("@")}" if @job_application.github_handle.present?
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
