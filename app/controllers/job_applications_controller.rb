# frozen_string_literal: true

class JobApplicationsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    authorize JobApplication
    filter = params[:filter].presence_in(Views::JobApplications::Index::FILTERS) || Views::JobApplications::Index::FILTERS.first
    applications = policy_scope(JobApplication).with_filter(filter).order(created_at: :desc)
    render Views::JobApplications::Index.new(job_applications: applications)
  end

  def new
    render Views::JobApplications::New.new(job_application: JobApplication.new)
  end

  def create
    job_application = JobApplication.new(job_application_attributes)
    if job_application.save
      job_application.publish(:submitted, job_application_id: job_application.id)
      redirect_to job_application, status: :see_other
    else
      render Views::JobApplications::New.new(job_application:), status: :unprocessable_content
    end
  end

  def show
    render Views::JobApplications::Show.new(job_application: authorize(JobApplication.find_by!(token: params[:id])))
  end

  private

  def job_application_attributes
    params.require(:job_application).permit(:job_role, :level, :first_name, :last_name, :email,
      :github_handle, :website_url, :available_from, :motivation, attachments: [])
  end
end
