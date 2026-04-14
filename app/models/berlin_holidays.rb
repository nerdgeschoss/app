# frozen_string_literal: true

class BerlinHolidays
  class << self
    def warm_cache!
      oldest_sprint_start = Date.new(2022, 1, 3) # Oldest Sprint in Production started on this day
      Holidays.cache_between(oldest_sprint_start, 1.year.from_now, :de_be)
    end

    def working_day?(date)
      return false if date.on_weekend?
      return false if Holidays.on(date, :de_be).any?

      true
    end

    def working_days_during(date_range)
      date_range.count do |date|
        working_day?(date)
      end
    end
  end
end
