# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfitCalculation do
  fixtures :users, :sprints, :sprint_feedbacks, :time_entries, :salaries, :leaves

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

    it "accumulates each user's running revenue, cost and profit across months" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      january_row = january_rows[john]
      february_row = february_rows[john]

      expect(january_row.running_revenue).to eq january_row.revenue
      expect(january_row.running_cost).to eq january_row.cost
      expect(january_row.running_profit).to eq january_row.revenue - january_row.cost

      expect(february_row.running_revenue).to be_within(0.01).of(january_row.revenue + february_row.revenue)
      expect(february_row.running_cost).to be_within(0.01).of(january_row.cost + february_row.cost)
      expect(february_row.running_profit).to be_within(0.01).of(
        (january_row.revenue - january_row.cost) + (february_row.revenue - february_row.cost)
      )
    end

    it "accumulates the total monthly revenue, cost and profit across months" do
      january = months_by_date[Date.new(2023, 1, 20)]
      february = months_by_date[Date.new(2023, 2, 1)]
      jan_revenue = january.rows.sum(&:revenue)
      jan_cost = january.rows.sum(&:cost)
      feb_revenue = february.rows.sum(&:revenue)
      feb_cost = february.rows.sum(&:cost)

      expect(january.total_running_revenue).to eq jan_revenue
      expect(january.total_running_cost).to eq jan_cost
      expect(january.total_running_profit).to eq jan_revenue - jan_cost

      expect(february.total_running_revenue).to be_within(0.01).of(jan_revenue + feb_revenue)
      expect(february.total_running_cost).to be_within(0.01).of(jan_cost + feb_cost)
      expect(february.total_running_profit).to be_within(0.01).of((jan_revenue - jan_cost) + (feb_revenue - feb_cost))
    end

    it "computes revenue as rounded_hours * billable_rate for billable entries in that month" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      # entry_1: john, created_at 2023-01-24, rounded_hours 1.5, billable_rate 100 → 150
      expect(january_rows[john].revenue).to eq 150
      expect(january_rows[users(:cigdem)].revenue).to eq 0
      expect(february_rows[john].revenue).to eq 0
    end

    it "aggregates the per-project revenue across users for each month" do
      january = months_by_date[Date.new(2023, 1, 20)]
      expect(january.revenue_by_project.size).to eq 1
      project = january.revenue_by_project.first
      expect(project.project).to eq "Some Project"
      expect(project.hours).to eq 1.5
      expect(project.revenue).to eq 150
    end

    it "exposes a per-project revenue and hours breakdown on each row" do
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      breakdown = january_rows[john].revenue_by_project
      expect(breakdown.size).to eq 1
      expect(breakdown.first.project).to eq "Some Project"
      expect(breakdown.first.hours).to eq 1.5
      expect(breakdown.first.revenue).to eq 150
    end

    describe "sick refund" do
      let(:working_days) do
        BerlinHolidays.count_working_days_during(Date.new(2023, 2, 1)..Date.new(2023, 2, 28))
      end

      before { john.leaves.destroy_all } # clear fixture leaves to control the input

      it "subtracts a 70% refund per sick day from the payroll employee's cost" do
        john.leaves.create!(title: "Flu", type: :sick, status: :approved,
          days: [Date.new(2023, 2, 6), Date.new(2023, 2, 7), Date.new(2023, 2, 8)])
        february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
        expected_refund = (3800 * 0.7 * 3 / working_days).round(2)
        expect(february_rows[john].sick_refund).to be_within(0.01).of(expected_refund)
        expect(february_rows[john].cost).to be_within(0.01).of(3800 * 1.21 + 10000 / 5.0 - expected_refund)
      end

      it "does not refund contractors" do
        john.current_salary.update!(employee: false)
        john.leaves.create!(title: "Flu", type: :sick, status: :approved, days: [Date.new(2023, 2, 7)])
        february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
        expect(february_rows[john].sick_refund).to eq 0
        expect(february_rows[john].cost).to eq 3800 + 10000 / 5.0
      end

      it "is zero when there are no sick days" do
        february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
        expect(february_rows[john].sick_refund).to eq 0
      end
    end

    it "buckets entries by created_at, not start_at" do
      time_entries(:entry_1).update_columns(start_at: Time.zone.local(2023, 1, 24), created_at: Time.zone.local(2023, 2, 10))
      january_rows = months_by_date[Date.new(2023, 1, 20)].rows.index_by(&:user)
      february_rows = months_by_date[Date.new(2023, 2, 1)].rows.index_by(&:user)
      expect(january_rows[john].revenue).to eq 0
      expect(february_rows[john].revenue).to eq 150
    end
  end
end
