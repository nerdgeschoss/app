# frozen_string_literal: true

class BerlinHolidays
  OLDEST_SPRINT_START = Date.new(2022, 1, 3).freeze # Oldest Sprint in Production started on this day
  ONE_YEAR_FROM_NOW = 1.year.from_now.freeze

  class << self
    def warm_cache!
      Holidays.cache_between(OLDEST_SPRINT_START, ONE_YEAR_FROM_NOW, :de_be)
    end

    def working_day?(date)
      return false if date.on_weekend?
      return false if Holidays.on(date, :de_be).any?

      true
    end

    def count_working_days_during(date_range)
      date_range.count do |date|
        working_day?(date)
      end
    end

    def upcoming_holidays
      Holidays.between(1.month.ago, ONE_YEAR_FROM_NOW, :de_be)
    end
  end
end
