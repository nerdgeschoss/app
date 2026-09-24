# frozen_string_literal: true

class JobApplications::InvitationsController < ApplicationController
  include Shimmer::RemoteNavigation

  before_action :authenticate_user!
  before_action :assign_job_application

  def new
    preset = JobApplication::InterviewPreset.find(params[:preset]) || JobApplication::InterviewPreset.all.first
    invitation = JobApplication::Invitation.new(job_application: @job_application,
      scheduling_url: preset.scheduling_url, message: preset.message(@job_application))
    render Views::JobApplications::Invitations::New.new(invitation:, preset:), layout: false
  end

  def create
    invitation = JobApplication::Invitation.new(job_application: @job_application, **invitation_attributes)
    if invitation.save
      ui.navigate_to job_application_path(@job_application)
    else
      render Views::JobApplications::Invitations::New.new(invitation:), layout: false, status: :unprocessable_content
    end
  end

  private

  def assign_job_application
    @job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :invite?
  end

  def invitation_attributes
    params.require(:job_application_invitation).permit(:scheduling_url, :message).to_h.symbolize_keys
  end
end
