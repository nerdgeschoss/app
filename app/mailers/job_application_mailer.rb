# frozen_string_literal: true

class JobApplicationMailer < ApplicationMailer
  def interview_invitation = deliver_text

  def rejection = deliver_text

  private

  # The body is exactly what HR wrote in the modal, so it goes out as plain text.
  def deliver_text
    mail(to: params[:job_application].email, subject: default_i18n_subject) do |format|
      format.text { render plain: params[:text] }
    end
  end
end
