# frozen_string_literal: true

calendar = Icalendar::Calendar.new
calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", "nerdgeschoss Holidays")
@leaves.each do |leave|
  ics = leave.to_ics
  calendar.add_event ics if ics
end
calendar.to_ical
