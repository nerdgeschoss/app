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
end
