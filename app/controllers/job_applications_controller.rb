# frozen_string_literal: true

class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize JobApplication
    filter = params[:filter].presence_in(Views::JobApplications::Index::FILTERS) || Views::JobApplications::Index::FILTERS.first
    applications = policy_scope(JobApplication).with_filter(filter).order(created_at: :desc)
    render Views::JobApplications::Index.new(job_applications: applications)
  end
end
