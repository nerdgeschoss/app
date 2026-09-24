# frozen_string_literal: true

class Views::JobApplications::Invitations::New < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  prop :invitation, JobApplication::Invitation
  prop :preset, _Nilable(JobApplication::InterviewPreset)

  def view_template
    # A frame, so preset links and a failed submit swap only the modal's content.
    turbo_frame_tag "job_application_modal" do
      stack do
        text(type: "h3-bold") { t(".title") }
        stack(line: "mobile", size: 4) do
          JobApplication::InterviewPreset.all.each do |preset|
            a(href: new_job_application_invitation_path(job_application, preset: preset.kind)) do
              render(Components::Pill.new(active: preset.kind == @preset&.kind)) { preset.title }
            end
          end
        end
        form_with(model: @invitation, url: job_application_invitation_path(job_application)) do |form|
          stack(size: 16) do
            form.url_field :scheduling_url
            form.text_area :message, rows: 12
            form.submit t(".submit")
          end
        end
      end
    end
  end

  private

  def job_application
    @invitation.job_application
  end
end
