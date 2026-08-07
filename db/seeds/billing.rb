# frozen_string_literal: true

projects.create :customer_project, name: "Customer Project", client_name: "Some Client",
  repository: "nerdgeschoss/customer-project", framework_versions: {ruby: "3.1", rails: "7.0"}
projects.create :internal_project, name: "Internal Tool", client_name: "nerdgeschoss", framework_versions: {}
projects.create :archived_project, name: "Old Client Work", client_name: "Old Client", archived: true, framework_versions: {}
invoice_project = projects.create :invoice_project, name: "Invoice Test Project", client_name: "Invoice Client", framework_versions: {}

invoices.create :paid_invoice, project: invoice_project, reference: "INV-001", amount: 1000.0, state: "paid",
  paid_at: Time.utc(2024, 1, 15), sent_at: Time.utc(2024, 1, 1), harvest_id: 1001
invoices.create :open_invoice, project: invoice_project, reference: "INV-002", amount: 500.0, state: "open",
  sent_at: Time.utc(2024, 2, 1), harvest_id: 1002

time_entries.create :entry_1, user: users.john, sprint: sprints.empty,
  hours: 1.2,
  rounded_hours: 1.5,
  billable: true,
  billable_rate: 100.0,
  created_at: Time.utc(2023, 1, 24, 10),
  start_at: Time.utc(2023, 1, 24, 10),
  project_name: "Some Project",
  client_name: "Some Client",
  task: "Programming",
  external_id: "ext_12345",
  invoiced: false
