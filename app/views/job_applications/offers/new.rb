# frozen_string_literal: true

class Views::JobApplications::Offers::New < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  prop :offer, JobApplication::Offer

  def view_template
    # A frame, so a failed submit swaps only the modal's content.
    turbo_frame_tag "job_application_modal" do
      stack(size: 32) do
        text(type: "h5-bold") { t(".title") }
        form_with(model: @offer, url: job_application_offer_path(@offer.job_application)) do |form|
          stack(size: 32) do
            stack(size: 24) do
              form.select :offered_level, level_choices
              form.text_area :message, rows: 14
            end
            stack(line: "mobile", justify: "right") { form.submit t(".submit") }
          end
        end
      end
    end
  end

  private

  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def level_choices
    JobApplication.offered_levels.keys.map { [t("job_application.level.#{it}"), it] }
  end
end
