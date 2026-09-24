# frozen_string_literal: true

class JobApplications::BookingsController < ApplicationController
  before_action :assign_booking

  def create
    @booking.book!
    redirect_to job_application_path(@booking.job_application), status: :see_other
  end

  def destroy
    @booking.reset!
    redirect_to job_application_path(@booking.job_application), status: :see_other
  end

  private

  def assign_booking
    job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :book?
    @booking = JobApplication::Booking.new(job_application)
  end
end
