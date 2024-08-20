# frozen_string_literal: true

calendar = Icalendar::Calendar.new
calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", "nerdgeschoss Holidays")
@leaves.reject(&:rejected?).flat_map(&:to_ics).each { calendar.add_event _1 }
calendar.to_ical
