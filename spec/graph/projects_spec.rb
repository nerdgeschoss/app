# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects", type: :graph do
  fixtures :all
  let(:user) { users(:john) }
  let(:admin) { users(:admin) }
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

  context "filtering" do
    it "filters by status ACTIVE" do
      login(user)
      gql <<~GRAPHQL
        { projects(status: ACTIVE) { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to include("Customer Project", "Internal Tool")
      expect(names).not_to include("Old Client Work")
    end

    it "filters by status ARCHIVED" do
      login(user)
      gql <<~GRAPHQL
        { projects(status: ARCHIVED) { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to eq(["Old Client Work"])
    end

    it "filters by category INTERNAL" do
      login(user)
      gql <<~GRAPHQL
        { projects(category: INTERNAL) { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to eq(["Internal Tool"])
    end

    it "filters by category CUSTOMERS" do
      login(user)
      gql <<~GRAPHQL
        { projects(category: CUSTOMERS) { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to include("Customer Project", "Old Client Work")
      expect(names).not_to include("Internal Tool")
    end

    it "combines status and category filters" do
      login(user)
      gql <<~GRAPHQL
        { projects(status: ACTIVE, category: CUSTOMERS) { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to eq(["Customer Project"])
    end

    it "filters by search matching project name" do
      login(user)
      gql <<~GRAPHQL
        { projects(search: "internal") { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to eq(["Internal Tool"])
    end

    it "filters by search matching client name" do
      login(user)
      gql <<~GRAPHQL
        { projects(search: "some client") { nodes { name } } }
      GRAPHQL
      names = data.projects.nodes.map(&:name)
      expect(names).to eq(["Customer Project"])
    end
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
