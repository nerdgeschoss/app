# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:project) { projects(:customer_project) }

  it "finds a project by id or repository" do
    login(user)
    query = <<~GRAPHQL
      query Project($id: ID!) {
        project(id: $id) {
          name
        }
      }
    GRAPHQL
    gql query, variables: {id: project.id}
    expect(data.project.name).to eq "Customer Project"
    gql query, variables: {id: project.repository}
    expect(data.project.name).to eq "Customer Project"
  end

  context "restricting financial fields" do
    it "restricts financial details for non-hr employees" do
      login(user)
      ["openInvoiceAmount", "openInvoiceCount", "lastInvoiced", "invoicedRevenue", "uninvoicedRevenue"].each do |field|
        gql <<~GRAPHQL, variables: {id: project.id}
          query Project($id: ID!) {
            project(id: $id) {
              #{field}
            }
          }
        GRAPHQL
        expect(gql_errors.first.message).to include("hidden due to permissions"), "expected #{field} to be restricted"
      end

      gql <<~GRAPHQL, variables: {id: project.id}
        query Project($id: ID!) {
          project(id: $id) {
            invoices { nodes { reference } }
          }
        }
      GRAPHQL
      expect(gql_errors.first.message).to include "hidden due to permissions"
    end

    it "shows financial details for hr employees" do
      login(users(:admin))
      gql <<~GRAPHQL, variables: {id: project.id}
        query Project($id: ID!) {
          project(id: $id) {
            openInvoiceAmount
            openInvoiceCount
            lastInvoiced
            invoicedRevenue
            uninvoicedRevenue
            invoices { nodes { reference } }
          }
        }
      GRAPHQL
      expect(data.project.open_invoice_amount).not_to be_nil
      expect(data.project.open_invoice_count).not_to be_nil
      expect(data.project.invoiced_revenue).not_to be_nil
      expect(data.project.uninvoiced_revenue).not_to be_nil
    end
  end
end
