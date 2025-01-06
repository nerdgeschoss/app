# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reaction::Props::Schema do
  describe "#initialize" do
    it "parses a tree of properties using a DSL" do
      schema = Reaction::Props::Schema.new(Rails.root.join("spec/fixtures/files/example_schema.rb"))
      root = schema.root
      current_user = root.fields[:current_user]
      expect(root.name).to eq :root
      expect(root.type).to eq Object
      expect(root.null).to eq false
      expect(root.fields.keys).to match_array [:current_user, :sprint]
      expect(current_user.type).to eq Object
      expect(current_user.fields.keys).to match_array [:first_name, :email, :age]
      expect(current_user.fields[:first_name].type).to eq String
      expect(current_user.fields[:age].type).to eq Integer
    end

    describe "#serialize" do
      it "serializes a tree of properties" do
        schema = Reaction::Props::Schema.new(Rails.root.join("spec/fixtures/files/example_schema.rb"))
        serialized = schema.serialize(OpenStruct.new({
          current_user: {
            first_name: "John",
            email: "name@example.com",
            age: "30"
          }, sprint2: "some value"
        }))
        expect(serialized["current_user"]).to eq({
          "first_name" => "John",
          "email" => "name@example.com",
          "age" => 30
        })
        expect(serialized["sprint"]).to eq "some value"
      end
    end
  end
end
