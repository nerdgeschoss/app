# frozen_string_literal: true

class JobApplications::OffersController < ApplicationController
  include Shimmer::RemoteNavigation

  before_action :authenticate_user!
  before_action :assign_job_application

  def new
    offer = JobApplication::Offer.new(job_application: @job_application, offered_level: @job_application.level,
      message: I18n.t("job_application.offer.message", name: @job_application.first_name, position: @job_application.position))
    render Views::JobApplications::Offers::New.new(offer:), layout: false
  end

  def create
    offer = JobApplication::Offer.new(job_application: @job_application, **offer_attributes)
    if offer.save
      ui.navigate_to job_application_path(@job_application)
    else
      render Views::JobApplications::Offers::New.new(offer:), layout: false, status: :unprocessable_content
    end
  end

  private

  def assign_job_application
    @job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :hire?
  end

  def offer_attributes
    params.require(:job_application_offer).permit(:offered_level, :message).to_h.symbolize_keys
  end
end
