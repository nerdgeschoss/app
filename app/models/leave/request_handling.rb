# frozen_string_literal: true

module Leave::RequestHandling
  extend ActiveSupport::Concern

  def handle_incoming_request
    case type
    when "sick"
      notify_slack_about_sick_leave
    when "paid", "unpaid"
      notify_hr_on_slack_about_new_request
    end

    set_slack_status! if leave_during.include?(Time.zone.today)
  end

  def handle_slack_status
    set_slack_status! if leave_during.include?(Time.zone.today) && approved?
  end
end
