# frozen_string_literal: true

class JobApplications::RejectionsController < ApplicationController
  include Shimmer::RemoteNavigation

  before_action :authenticate_user!
  before_action :assign_job_application

  # i18n-tasks-use t('job_application.rejection.review') t('job_application.rejection.interview')
  def new
    rejection = JobApplication::Rejection.new(job_application: @job_application,
      message: I18n.t("job_application.rejection.#{@job_application.status}", name: @job_application.first_name))
    render Views::JobApplications::Rejections::New.new(rejection:), layout: false
  end

  def create
    rejection = JobApplication::Rejection.new(job_application: @job_application, **rejection_attributes)
    if rejection.save
      ui.navigate_to job_application_path(@job_application)
    else
      render Views::JobApplications::Rejections::New.new(rejection:), layout: false, status: :unprocessable_content
    end
  end

  private

  def assign_job_application
    @job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :reject?
  end

  def rejection_attributes
    params.require(:job_application_rejection).permit(:message).to_h.symbolize_keys
  end
end
