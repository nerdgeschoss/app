# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reaction::Props::Schema do
  let(:example_schema) do
    <<~RUBY
      field :current_user do
        field :first_name
        field :email, null: false
        field :age, Integer
      end
      field :sprint, null: false, value: -> { sprint2 }
    RUBY
  end

  describe "#initialize" do
    it "parses a tree of properties using a DSL" do
      schema = Reaction::Props::Schema.new(example_schema)
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
        schema = Reaction::Props::Schema.new(example_schema)
        serialized = schema.serialize(OpenStruct.new({
          current_user: {
            first_name: "John",
            email: "name@example.com",
            age: "30"
          }, sprint2: "some value"
        }))
        expect(serialized["currentUser"]).to eq({
          "firstName" => "John",
          "email" => "name@example.com",
          "age" => 30
        })
        expect(serialized["sprint"]).to eq "some value"
      end
    end
  end
end
