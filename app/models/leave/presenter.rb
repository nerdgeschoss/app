# frozen_string_literal: true

class Leave::Presenter
  attr_reader :leave
  delegate_missing_to :@leave

  def initialize(leave)
    @leave = leave
  end

  def unicode_emoji
    case leave.type
    when "paid"
      "\u{1F3D6}" # :beach_with_umbrella:
    when "unpaid"
      "\u{1F3D5}" # :camping:
    when "non_working"
      "\u{1F9F3}" # :luggage:
    else
      "\u{1F912}" # :face_with_thermometer:
    end
  end

  def slack_emoji
    case leave.type
    when "paid", "unpaid"
      ":beach_with_umbrella:"
    when "non_working"
      ":luggage:"
    else
      ":face_with_thermometer:"
    end
  end

  def to_ics
    leave.days.sort.slice_when { |prev, curr| prev.next_day != curr }.map do |range|
      event = Icalendar::Event.new
      event.dtstart = Icalendar::Values::Date.new range.first
      event.dtstart.ical_params = {"VALUE" => "DATE"}
      event.dtend = Icalendar::Values::Date.new (range.length == 1) ? range.last : range.last.next_day
      event.dtend.ical_params = {"VALUE" => "DATE"}
      display_status = (leave.status == "pending_approval") ? " (#{I18n.t("leave.status.pending_approval")})" : ""
      event.summary = "#{leave.user.display_name}: #{leave.title} #{unicode_emoji} #{display_status}"
      event.url = Rails.application.routes.url_helpers.leaves_url(id: leave.id)
      event
    end
  end
end
