# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeavePolicy do
  subject { described_class.new(user, record) }

  fixtures :all
  let(:record) { user.leaves.create! type: :paid, title: "Holidays", days: [2.weeks.from_now, 15.days.from_now] }

  describe "for a regular user" do
    let(:user) { users(:john) } # regular user

    it { is_expected.to permit_action(:create) }
    it { is_expected.not_to permit_action(:hr_overview) }

    it "permits destruction of their own leave record if the leave is more than one week away" do
      is_expected.to permit_action(:destroy)
    end

    it "does not permit destruction of their own leave record if the leave is within one week" do
      record.leave_during = (Time.zone.today..6.days.from_now)
      is_expected.not_to permit_action(:destroy)
    end

    context "when the leave ends in the past" do
      it "does not permit updates" do
        record.leave_during = (5.days.ago..1.day.ago)
        is_expected.not_to permit_action(:update)
      end
    end

    context "when the leave ends today" do
      it "permits updates" do
        record.leave_during = (5.days.ago..Time.zone.today)
        is_expected.to permit_action(:update)
      end
    end

    context "when the leave ends in the future" do
      it "permits updates" do
        record.leave_during = (5.days.ago..1.day.from_now)
        is_expected.to permit_action(:update)
      end
    end
  end

  describe "for an HR user" do
    let(:user) { users(:admin) } # HR user

    it { is_expected.to permit_actions([:create, :destroy, :update, :hr_overview]) }

    describe "permitted_attributes" do
      it "returns all attributes" do
        expect(subject.permitted_attributes).to contain_exactly(:title, :type, :status, days: [])
      end
    end
  end
end
