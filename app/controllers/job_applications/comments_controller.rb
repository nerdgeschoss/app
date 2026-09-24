# frozen_string_literal: true

class JobApplications::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    job_application = authorize JobApplication.find_by!(token: params[:job_application_id]), :comment?
    comment = JobApplication::Comment.new(job_application:, author: current_user,
      body: params.require(:job_application_comment).permit(:body)[:body])
    if comment.save
      render Components::JobApplicationUpdates.new(job_application:, comment: JobApplication::Comment.new(job_application:)), layout: false
    else
      render Components::JobApplicationUpdates.new(job_application:, comment:), layout: false, status: :unprocessable_content
    end
  end
end
