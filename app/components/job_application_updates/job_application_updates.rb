# frozen_string_literal: true

# HR's timeline of an application: everything that happened to it, plus comments.
class Components::JobApplicationUpdates < Components::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  prop :job_application, JobApplication
  prop :comment, JobApplication::Comment

  # Commenting re-renders only this frame, not the whole page.
  def view_template
    turbo_frame_tag "job_application_updates" do
      render Components::Card.new(subtitle: -> { timeline }, with_divider: true) do
        form_with(model: @comment, url: job_application_comments_path(@job_application)) do |form|
          stack(size: 16) do
            form.text_area :body, label: false, placeholder: t(".placeholder"), rows: 1
            stack(line: "mobile", justify: "right") { form.submit t(".submit"), variant: "secondary" }
          end
        end
      end
    end
  end

  private

  # i18n-tasks-use t('components.job_application_updates.events.submitted') t('components.job_application_updates.events.interview_invited')
  # i18n-tasks-use t('components.job_application_updates.events.interview_booked') t('components.job_application_updates.events.craft_interview_invited')
  # i18n-tasks-use t('components.job_application_updates.events.craft_interview_booked') t('components.job_application_updates.events.offered')
  # i18n-tasks-use t('components.job_application_updates.events.rejected') t('components.job_application_updates.events.hired')
  def timeline
    stack(size: 24) do
      text(type: "body-bold") { t(".title") }
      stack(size: 12) do
        events.each { |event| (event.name == "commented") ? comment_row(event) : event_row(event) }
      end
    end
  end

  def event_row(event)
    stack(line: "mobile", size: 24, justify: "space-between", align: "top") do
      timestamp(event)
      text(type: "caption-primary-regular", align: "right") { t(".events.#{event.name}", default: event.name.humanize) }
    end
  end

  def comment_row(event)
    author = authors[event.payload["author_id"]]
    stack(size: 8) do
      stack(line: "mobile", size: 24, justify: "space-between", align: "center") do
        timestamp(event)
        if author
          stack(line: "mobile", size: 8, align: "center", full_width: "none") do
            render Components::Avatar.new(email: author.email, display_name: author.display_name, avatar_url: author.avatar_image(size: 40), small: true)
            text(type: "caption-primary-regular") { author.display_name }
          end
        end
      end
      text(type: "caption-primary-regular") { event.payload["body"] }
    end
  end

  def timestamp(event)
    stack(full_width: "none", no_shrink: true) do
      text(type: "caption-primary-bold", no_wrap: true) { l(event.created_at, format: :long) }
    end
  end

  def events
    @events ||= @job_application.events.to_a
  end

  def authors
    @authors ||= User.where(id: events.filter_map { it.payload["author_id"] }).index_by(&:id)
  end
end
