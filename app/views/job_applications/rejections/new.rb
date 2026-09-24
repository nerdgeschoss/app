# frozen_string_literal: true

class Views::JobApplications::Rejections::New < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  prop :rejection, JobApplication::Rejection

  def view_template
    # A frame, so a failed submit swaps only the modal's content.
    turbo_frame_tag "job_application_modal" do
      stack do
        text(type: "h3-bold") { t(".title") }
        form_with(model: @rejection, url: job_application_rejection_path(@rejection.job_application)) do |form|
          stack(size: 16) do
            form.text_area :message, rows: 12
            form.submit t(".submit")
          end
        end
      end
    end
  end
end
