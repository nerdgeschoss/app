# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class.new(user, record) }

  fixtures :all

  let(:record) { users(:john) }

  context "for an employee" do
    let(:user) { users(:cigdem) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(:create, :destroy, :update, :unpaid_vacation, :financial_details, :leaves) }
  end

  context "for the owning user" do
    let(:user) { users(:john) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(:create, :destroy) }
    it { is_expected.to permit_actions(:update, :unpaid_vacation, :financial_details, :leaves) }
  end

  context "for an HR user" do
    let(:user) { users(:admin) }

    it { is_expected.to permit_actions(:show, :create, :update, :destroy, :unpaid_vacation, :financial_details, :leaves) }
  end
end
