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
# spec/models/bank_holiday_spec.rb
require "rails_helper"

RSpec.describe BankHoliday, type: :model do
  describe ".in_year" do
    let(:year) { 2022 }
    let(:dates) { [Date.new(2022, 1, 1), Date.new(2022, 12, 25)] }
    let(:bank_holiday) { BankHoliday.create! year:, dates: }

    before do
      allow(BankHoliday::FeiertageApi.instance).to receive(:retrieve_bank_holidays).with(year: year).and_return(dates)
    end

    it "returns bank holidays for the specified year" do
      expect(BankHoliday.in_year(year)).to eq(dates)
    end
  end

  describe ".weekday_dates_in_years" do
    let(:years) { [2021, 2022] }
    let(:dates_2021) { [Date.new(2021, 1, 1), Date.new(2021, 12, 25)] }
    let(:dates_2022) { [Date.new(2022, 1, 1), Date.new(2022, 12, 25)] }

    before do
      BankHoliday.create! year: 2021, dates: dates_2021
      BankHoliday.create! year: 2022, dates: dates_2022
    end

    it "returns weekday bank holidays for the specified years" do
      expect(BankHoliday.weekday_dates_in_years(years)).to eq([Date.new(2021, 1, 1)])
    end
  end

  describe "#dates_during_weekdays" do
    let(:bank_holiday) { BankHoliday.create! year: 2023, dates: [Date.new(2022, 1, 1), Date.new(2022, 12, 25)] }

    it "returns only weekday dates" do
      expect(bank_holiday.dates_during_weekdays).to be_empty
    end
  end

  describe "#fetch_bank_holidays" do
    let(:year) { 2023 }
    let(:dates) { [Date.new(2023, 1, 1), Date.new(2023, 12, 25)] }
    let(:holiday) { BankHoliday.create! year: year, dates: [] }

    it "updates the bank_holiday with dates from the API" do
      allow(BankHoliday::FeiertageApi.instance).to receive(:retrieve_bank_holidays).with(year:).and_return(dates)

      holiday.send(:fetch_bank_holidays)

      expect(holiday.reload.dates).to eq(dates)
    end
  end
end
