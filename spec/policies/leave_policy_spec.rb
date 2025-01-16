# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeavePolicy do
  subject { described_class.new(user, record) }

  fixtures :all
  let(:record) { user.leaves.create! type: :paid, title: "Holidays", days: [2.weeks.from_now, 15.days.from_now] }

  describe "for a regular user" do
    let(:user) { users(:john) } # regular user

    it { is_expected.to permit_action(:create) }

    it "permits destruction of their own leave record if the leave is more than one week away" do
      is_expected.to permit_action(:destroy)
    end

    it "does not permit destruction of their own leave record if the leave is within one week" do
      record.leave_during = (Time.zone.today..6.days.from_now)
      is_expected.not_to permit_action(:destroy)
    end

    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:show_all_users) }

    describe "Scope" do
      it "includes only leave records belonging to the user" do
        expect(Pundit.policy_scope!(user, Leave)).to eq(user.leaves)
      end
    end
  end

  describe "for an HR user" do
    let(:user) { users(:admin) } # HR user

    it { is_expected.to permit_actions([:create, :destroy, :update, :show_all_users]) }

    describe "Scope" do
      it "includes all leave records" do
        expect(Pundit.policy_scope!(user, Leave.all)).to include(subject.record)
        expect(Pundit.policy_scope!(user, Leave.all).count).to eq Leave.count
      end
    end

    describe "permitted_attributes" do
      it "returns all attributes" do
        expect(subject.permitted_attributes).to contain_exactly(:title, :type, :user_id, :status, days: [])
      end
    end
  end
end
