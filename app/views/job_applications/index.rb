# frozen_string_literal: true

class Views::JobApplications::Index < Views::Base
  FILTERS = ["new", "rejected", "joined"].freeze

  prop :job_applications, _Enumerable(JobApplication)

  def view_template
    refresh_by_morphing
    render Components::Layout.new(user: current_user, container: true) do
      turbo_stream_from "job_applications"
      stack do
        text(type: "h1-bold") { t(".title") }
        render Components::NavigationPills.new(filters:)
        @job_applications.each { |job_application| render Components::JobApplicationCard.new(job_application:) }
      end
    end
  end

  private

  def filters
    # i18n-tasks-use t('job_applications.index.filters.joined') t('job_applications.index.filters.new') t('job_applications.index.filters.rejected')
    FILTERS.index_with { |name| t(".filters.#{name}") }
  end
end
