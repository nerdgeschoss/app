# frozen_string_literal: true

class ProfitCalculation
  EMPLOYER_SURCHARGE = BigDecimal("1.21").freeze
  FIXED_COSTS_PER_MONTH = BigDecimal(10000).freeze

  Row = Data.define(:revenue, :cost, :running, :salary, :payroll_taxes, :benefits, :fixed_share, :revenue_by_project, :user).freeze
  Month = Data.define(:date, :rows, :total_running).freeze
  ProjectRevenue = Data.define(:project, :hours, :revenue).freeze

  attr_reader :range

  def initialize(range)
    @range = range
  end

  def months
    breakdown = TimeEntry.billable
      .where(created_at: range.begin.beginning_of_day..range.end.end_of_day)
      .group(:user_id, Arel.sql("date_trunc('month', created_at)::date"), :project_name)
      .pluck(
        :user_id,
        Arel.sql("date_trunc('month', created_at)::date"),
        :project_name,
        Arel.sql("SUM(rounded_hours)"),
        Arel.sql("SUM(rounded_hours * billable_rate)")
      )
    revenue_lookup = Hash.new(0)
    projects_lookup = Hash.new { |h, k| h[k] = [] }
    breakdown.each do |user_id, month_date, project_name, hours, project_revenue|
      revenue_lookup[[user_id, month_date]] += project_revenue
      projects_lookup[[user_id, month_date]] << ProjectRevenue.new(project: project_name, hours:, revenue: project_revenue)
    end

    active_users = User
      .joins(sprint_feedbacks: :sprint)
      .group("users.id")
      .select(
        "users.*",
        "MIN(LOWER(sprints.sprint_during)) AS active_from",
        "MAX(UPPER(sprints.sprint_during)) AS active_until"
      )
      .sort_by(&:display_name)

    salaries_by_user = Salary.where(user_id: active_users.map(&:id))
      .where(valid_from: ..range.end)
      .order(:valid_from)
      .group_by(&:user_id)

    user_running = Hash.new(0)
    total_running = 0

    month_dates.map do |month_date|
      key = month_date.beginning_of_month
      slice_end = [month_date.end_of_month, range.end].min
      days_in_slice = (slice_end - month_date + 1).to_i
      days_in_month = month_date.end_of_month.day

      active_in_month = active_users.select do |user|
        user.active_from.to_date <= slice_end && user.active_until.to_date > month_date
      end
      fixed_share = active_in_month.empty? ? 0 : FIXED_COSTS_PER_MONTH * days_in_slice / days_in_month / active_in_month.size

      rows = active_in_month.map do |user|
        salary = salaries_by_user[user.id]&.select { |s| s.valid_from <= slice_end }&.last
        if salary
          salary_amount = (salary.brut * days_in_slice / days_in_month).round(2)
          payroll_taxes = salary.employee? ? (salary.brut * (EMPLOYER_SURCHARGE - 1) * days_in_slice / days_in_month).round(2) : 0
          benefits = (salary.deutschlandticket * days_in_slice / days_in_month).round(2)
        else
          salary_amount = 0
          payroll_taxes = 0
          benefits = 0
        end

        revenue = revenue_lookup[[user.id, key]]
        rounded_fixed_share = fixed_share.round(2)
        cost = salary_amount + payroll_taxes + benefits + rounded_fixed_share
        profit = revenue - cost
        user_running[user.id] += profit
        total_running += profit

        Row.new(revenue:, cost:, running: user_running[user.id],
          salary: salary_amount, payroll_taxes:, benefits:, fixed_share: rounded_fixed_share,
          revenue_by_project: projects_lookup[[user.id, key]], user:)
      end
      Month.new(date: month_date, rows:, total_running:)
    end
  end

  private

  def month_dates
    [].tap do |result|
      cursor = range.begin
      while cursor <= range.end
        result << [cursor.beginning_of_month, range.begin].max
        cursor = cursor.end_of_month + 1.day
      end
    end
  end
end
