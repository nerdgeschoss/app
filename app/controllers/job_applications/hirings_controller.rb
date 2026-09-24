# frozen_string_literal: true

class JobApplications::HiringsController < ApplicationController
  before_action :authenticate_user!

  def create
    job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :mark_hired?
    job_application.hire!
    redirect_to job_application_path(job_application), status: :see_other
  end
end
