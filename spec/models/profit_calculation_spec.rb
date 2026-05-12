# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfitCalculation do
  fixtures :users, :sprints, :sprint_feedbacks, :time_entries, :salaries

  describe "#months" do
    let(:john) { users(:john) }
    let(:calculation) { described_class.new(Date.new(2023, 1, 20)..Date.new(2023, 3, 10)) }
    let(:active_users) do
      [users(:john), users(:john_no_slack), users(:cigdem), users(:yuki), users(:zacharias)]
    end
    let(:months_by_date) { calculation.months.index_by(&:date) }

    it "uses the range start for the first month and first-of-month thereafter" do
      expect(calculation.months.map(&:date))
        .to contain_exactly(Date.new(2023, 1, 20), Date.new(2023, 2, 1), Date.new(2023, 3, 1))
    end

    it "includes only users whose active range (first to last sprint) overlaps the month-slice" do
      expect(months_by_date[Date.new(2023, 1, 20)].rows.map(&:user)).to match_array(active_users)
      expect(months_by_date[Date.new(2023, 2, 1)].rows.map(&:user)).to match_array(active_users)
      # The fixture sprint ends 2023-02-03, so March still appears but has no rows.
      expect(months_by_date[Date.new(2023, 3, 1)].rows).to be_empty
    end

    it "returns the full User record on each row" do
      row = months_by_date[Date.new(2023, 1, 20)].rows.find { |r| r.user == john }
      expect(row.user.email).to eq john.email
    end

    it "applies the 1.21 employer surcharge to the brut salary and prorates by days in the slice" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      fixed_share = 10000 / 5.0  # 5 active users → 2000 each (full month)
      # John's current salary (valid_from 2022-01-01) is brut 3800, employee: true.
      # January slice 2023-01-20..2023-01-31 = 12 days, calendar month = 31 days.
      expect(january_rows[john].cost).to be_within(0.01).of((3800 * 1.21 + 10000 / 5.0) * 12 / 31.0)
      # February is fully within the range, so no proration.
      expect(february_rows[john].cost).to eq 3800 * 1.21 + fixed_share
    end

    it "adds the deutschlandticket net cost on top of the surcharged brut" do
      john.current_salary.update!(deutschlandticket: 49)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      expect(february_rows[john].cost).to eq 3800 * 1.21 + 49 + 10000 / 5.0
    end

    it "skips the employer surcharge for contractors (employee: false)" do
      john.current_salary.update!(employee: false)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      expect(february_rows[john].cost).to eq 3800 + 10000 / 5.0
    end

    it "splits the monthly fixed costs equally among active users" do
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      # 5 active users, 10000 fixed costs, full month → 2000 each.
      # Cigdem has no salary → her cost is the fixed share alone.
      expect(february_rows[users(:cigdem)].cost).to eq 10000 / 5.0
    end

    it "prorates the fixed share for partial months" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      # 12/31 of the month, 5 active users → 10000 * 12 / 31 / 5.
      expect(january_rows[users(:cigdem)].cost).to be_within(0.01).of(10000 * 12 / 31.0 / 5)
    end

    it "computes revenue as rounded_hours * billable_rate for billable entries in that month" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      # entry_1: john, 2023-01-24, rounded_hours 1.5, billable_rate 100 → 150
      expect(january_rows[john].revenue).to eq 150
      expect(january_rows[users(:cigdem)].revenue).to eq 0
      expect(february_rows[john].revenue).to eq 0
    end
  end
end
