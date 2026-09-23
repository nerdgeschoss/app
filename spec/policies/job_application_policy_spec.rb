# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationPolicy do
  subject { described_class.new(user, record) }

  fixtures :all
  let(:record) { job_applications(:max_review) }

  describe "for a regular user" do
    let(:user) { users(:john) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }

    describe "Scope" do
      it "is empty" do
        expect(Pundit.policy_scope!(user, JobApplication)).to be_empty
      end
    end
  end

  describe "for hr" do
    let(:user) { users(:admin) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }

    describe "Scope" do
      it "includes every application" do
        expect(Pundit.policy_scope!(user, JobApplication)).to eq JobApplication.all
      end
    end
  end
end
