# frozen_string_literal: true

Yael::Bus.shared.routing do
  dispatch :all, to: "job_application.refresh_page"
end
