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
      render Components::Card.new(title: t(".title")) do
        stack(size: 16) do
          events.each { |event| (event.name == "commented") ? comment_row(event) : event_row(event) }
          form_with(model: @comment, url: job_application_comments_path(@job_application)) do |form|
            stack(size: 8) do
              form.text_area :body, placeholder: t(".placeholder"), rows: 3
              form.submit t(".submit")
            end
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
  def event_row(event)
    stack(line: "mobile", justify: "space-between") do
      text(type: "body-bold") { l(event.created_at, format: :long) }
      text { t(".events.#{event.name}", default: event.name.humanize) }
    end
  end

  def comment_row(event)
    author = authors[event.payload["author_id"]]
    stack(size: 4) do
      stack(line: "mobile", justify: "space-between", align: "center") do
        text(type: "body-bold") { l(event.created_at, format: :long) }
        if author
          stack(line: "mobile", size: 4, align: "center") do
            render Components::Avatar.new(email: author.email, display_name: author.display_name, avatar_url: author.avatar_image(size: 40))
            text { author.display_name }
          end
        end
      end
      text { event.payload["body"] }
    end
  end

  def events
    @events ||= @job_application.events.to_a
  end

  def authors
    @authors ||= User.where(id: events.filter_map { it.payload["author_id"] }).index_by(&:id)
  end
end
