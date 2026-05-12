# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ProfitReport", type: :graph do
  fixtures :all

  let(:admin) { users(:admin) }
  let(:john) { users(:john) }

  describe "top-level profitReport" do
    let(:query) do
      <<~GRAPHQL
        query Profit($fromDate: ISO8601Date!, $toDate: ISO8601Date!) {
          profitReport(fromDate: $fromDate, toDate: $toDate) {
            months {
              date
              totalCost
              totalRevenue
              totalProfit
              totalRunningRevenue
              totalRunningCost
              totalRunningProfit
              revenueByProject { project hours revenue }
              rows {
                cost
                revenue
                profit
                salary
                payrollTaxes
                benefits
                fixedShare
                runningCost
                runningRevenue
                runningProfit
                revenueByProject { project hours revenue }
                user { id displayName }
              }
            }
          }
        }
      GRAPHQL
    end
    let(:variables) { {fromDate: "2023-01-20", toDate: "2023-03-10"} }

    it "returns months and rows for an HR caller" do
      login(admin)
      gql(query, variables:)
      dates = data.profit_report.months.map(&:date)
      expect(dates).to contain_exactly("2023-01-20", "2023-02-01", "2023-03-01")
      january = data.profit_report.months.find { _1.date == "2023-01-20" }
      johns_row = january.rows.find { _1.user.id == john.id }
      expect(johns_row.revenue).to eq 150
      expect(johns_row.revenue_by_project.first.project).to eq "Some Project"
    end

    it "matches the values returned by the underlying model" do
      login(admin)
      gql(query, variables:)
      from = Date.parse(variables[:fromDate])
      to = Date.parse(variables[:toDate])
      expected = ProfitCalculation.new(from..to).months.find { _1.date == Date.new(2023, 1, 20) }
      january = data.profit_report.months.find { _1.date == "2023-01-20" }
      expected_johns_row = expected.rows.find { _1.user.id == john.id }
      johns_row = january.rows.find { _1.user.id == john.id }
      expect(johns_row.cost).to be_within(0.01).of(expected_johns_row.cost.to_f)
      expect(johns_row.running_profit).to be_within(0.01).of(expected_johns_row.running_profit.to_f)
    end

    it "rejects a non-HR caller" do
      login(john)
      gql(query, variables:)
      errors = result(skip_errors: true)["errors"]
      expect(errors).to be_present
      expect(errors.first["message"]).to match(/hidden due to permissions/i)
    end

    it "rejects an anonymous caller" do
      gql(query, variables:)
      expect(result(skip_errors: true)["errors"]).to be_present
    end
  end

  describe "Sprint#profitReport" do
    let(:sprint) { sprints(:empty) }
    let(:query) do
      <<~GRAPHQL
        query SprintProfit($id: ID!) {
          sprint(id: $id) {
            profitReport {
              months {
                date
                totalProfit
              }
            }
          }
        }
      GRAPHQL
    end

    it "exposes the sprint-scoped report to HR" do
      login(admin)
      gql query, variables: {id: sprint.id}
      months = data.sprint.profit_report.months
      expect(months).not_to be_empty
      expect(months.map(&:date).first).to start_with("2023-01")
    end

    it "denies non-HR" do
      login(john)
      gql query, variables: {id: sprint.id}
      errors = result(skip_errors: true)["errors"]
      expect(errors).to be_present
      expect(errors.first["message"]).to match(/hidden due to permissions/i)
    end
  end
end
