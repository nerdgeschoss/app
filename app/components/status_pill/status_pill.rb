# frozen_string_literal: true

class Components::StatusPill < Components::Base
  VALID_STATUSES = ["todo", "in_progress", "review", "done"].freeze

  prop :title, String
  prop :status, String

  def view_template
    return unless VALID_STATUSES.include?(@status)

    div(class: "status-pill status-pill--#{@status}") do
      text(type: :"status-pill") { @title }
    end
  end
end
