# frozen_string_literal: true

class LeavePresenter
  attr_reader :leave

  def initialize(leave)
    @leave = leave
  end

  def unicode_emoji
    case leave.type
    when "paid"
      "\u{1F3D6}"
    when "unpaid"
      "\u{1F3D5}"
    when "non_working"
      "\u{1F9F3}"
    else
      "\u{1F912}"
    end
  end

  def slack_emoji
    case leave.type
    when "paid", "unpaid"
      ":palm_tree:"
    when "non_working"
      ":luggage:"
    else
      ":face_with_thermometer:"
    end
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::Date.new leave.leave_during.min
    event.dtstart.ical_params = {"VALUE" => "DATE"}
    event.dtend = Icalendar::Values::Date.new leave.leave_during.max + 1.day
    event.dtend.ical_params = {"VALUE" => "DATE"}
    display_status = (leave.status == "pending_approval") ? " (#{I18n.t("leave.status.pending_approval")})" : ""
    event.summary = "#{leave.user.display_name}: #{leave.title} #{unicode_emoji} #{display_status}"
    event.url = Rails.application.routes.url_helpers.leaves_url(id: leave.id)
    event
  end
end
