# frozen_string_literal: true

class Views::JobApplications::Show < Views::Base
  prop :job_application, JobApplication

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack do
        text(type: "h1-bold") { t(".title") }
        render Components::Card.new(title: @job_application.full_name)
      end
    end
  end
end
