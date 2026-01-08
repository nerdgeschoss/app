# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project do
  fixtures :all

  let(:project) { projects(:customer_project) }
  let(:sprint) { sprints(:empty) }
  let(:user) { users(:john) }

  it "has data on invoices" do
    project.invoices.create!(state: "paid", amount: 150.0, sent_at: 1.month.ago, harvest_id: 124, reference: "INV-001")
    invoice2 = project.invoices.create!(state: "open", amount: 200.0, sent_at: 1.week.ago, harvest_id: 123, reference: "INV-002")
    project.invoices.create!(state: "draft", amount: 200.0, sent_at: nil, harvest_id: 125, reference: "INV-003")
    project.time_entries.create!(created_at: 2.days.ago, billable: true, hours: 5, rounded_hours: 5, billable_rate: 50.0, user:, sprint:, project_name: "something", client_name: "KS", task: "Development")
    expect(project.open_invoice_count).to eq 1
    expect(project.open_invoice_amount).to eq 200.0
    expect(project.last_invoiced).to eq invoice2.sent_at
    expect(project.invoiced_revenue).to eq 350.0
    expect(project.uninvoiced_revenue).to eq 250.0
  end
end
