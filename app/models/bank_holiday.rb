# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_holidays
#
#  id         :uuid             not null, primary key
#  year       :integer          not null
#  dates      :date             default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BankHoliday < ApplicationRecord
  validates :year, presence: true, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
  after_create :fetch_bank_holidays

  class << self
    def in_year(year)
      find_or_create_by(year:).dates
    end

    def weekday_dates_in_years(years)
      years.map { |year| find_or_create_by(year:).dates.reject { |date| date.saturday? || date.sunday? } }.flatten
    end
  end

  def dates_during_weekdays
    dates.reject { |date| date.saturday? || date.sunday? }
  end

  private

  def fetch_bank_holidays
    dates = BankHoliday::FeiertageApi.instance.retrieve_bank_holidays(year:)
    update!(dates:)
  end
end
