# frozen_string_literal: true

class BerlinHolidays
  class << self
    def warm_cache!
      start_date = Sprint.chronologic.first&.sprint_from || 1.year.ago
      Holidays.cache_between(start_date, 1.year.from_now, :de_be)
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
