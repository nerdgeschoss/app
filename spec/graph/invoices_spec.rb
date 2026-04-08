# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Invoices", type: :graph do
  fixtures :all
  let(:admin) { users(:admin) }
  let(:user) { users(:john) }
  let(:paid_invoice) { invoices(:paid_invoice) }
  let(:open_invoice) { invoices(:open_invoice) }

  it "returns no invoices for non-hr users" do
    login(user)
    gql <<~GRAPHQL
      { invoices { nodes { reference } } }
    GRAPHQL
    expect(data.invoices.nodes).to be_empty
  end

  it "lists all invoices for hr users" do
    login(admin)
    gql <<~GRAPHQL
      { invoices { nodes { reference } } }
    GRAPHQL
    references = data.invoices.nodes.map(&:reference)
    expect(references).to include(paid_invoice.reference, open_invoice.reference)
  end

  it "filters invoices by paid: true" do
    login(admin)
    gql <<~GRAPHQL
      { invoices(paid: true) { nodes { reference } } }
    GRAPHQL
    references = data.invoices.nodes.map(&:reference)
    expect(references).to include(paid_invoice.reference)
    expect(references).not_to include(open_invoice.reference)
  end

  it "filters invoices by paid: false" do
    login(admin)
    gql <<~GRAPHQL
      { invoices(paid: false) { nodes { reference } } }
    GRAPHQL
    references = data.invoices.nodes.map(&:reference)
    expect(references).to include(open_invoice.reference)
    expect(references).not_to include(paid_invoice.reference)
  end

  it "exposes the project on an invoice" do
    login(admin)
    gql <<~GRAPHQL
      { invoices { nodes { reference project { name } } } }
    GRAPHQL
    invoice_node = data.invoices.nodes.find { |n| n.reference == paid_invoice.reference }
    expect(invoice_node.project.name).to eq projects(:customer_project).name
  end

  it "filters project invoices by paid: true" do
    login(admin)
    gql <<~GRAPHQL, variables: {id: projects(:customer_project).id}
      query Project($id: ID!) {
        project(id: $id) {
          invoices(paid: true) { nodes { reference } }
        }
      }
    GRAPHQL
    references = data.project.invoices.nodes.map(&:reference)
    expect(references).to include(paid_invoice.reference)
    expect(references).not_to include(open_invoice.reference)
  end

  it "filters project invoices by paid: false" do
    login(admin)
    gql <<~GRAPHQL, variables: {id: projects(:customer_project).id}
      query Project($id: ID!) {
        project(id: $id) {
          invoices(paid: false) { nodes { reference } }
        }
      }
    GRAPHQL
    references = data.project.invoices.nodes.map(&:reference)
    expect(references).to include(open_invoice.reference)
    expect(references).not_to include(paid_invoice.reference)
  end
end
