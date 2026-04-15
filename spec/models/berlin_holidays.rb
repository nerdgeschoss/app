# frozen_string_literal: true

require "rails_helper"

RSpec.describe BerlinHolidays do
  describe ".working_day?" do
    it "returns true on a regular weekday" do
      result = BerlinHolidays.working_day?(Date.new(2026, 4, 1)) # Wednesday

      expect(result).to be true
    end

    it "returns false on the weekend" do
      result = BerlinHolidays.working_day?(Date.new(2026, 4, 4)) # Saturday

      expect(result).to be false
    end

    it "returns false on a Berlin holiday" do
      result = BerlinHolidays.working_day?(Date.new(2024, 3, 8)) # Friday, International Women's Day

      expect(result).to be false
    end

    it "returns true if it's only a holiday in other German states" do
      result = BerlinHolidays.working_day?(Date.new(2026, 6, 4)) # Thursday, Corpus Christi, but not a holiday in Berlin

      expect(result).to be true
    end
  end

  describe ".count_working_days_during" do
    it "returns the number of working days in the range" do
      start_of_easter = Date.new(2026, 3, 30)
      end_of_easter = Date.new(2026, 4, 11)
      working_days = BerlinHolidays.count_working_days_during(start_of_easter..end_of_easter)

      expect(working_days).to eq(8) # 12 days - 2 weekend - good friday - easter monday
    end
  end
end
