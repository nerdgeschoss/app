# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeavePolicy do
  subject { described_class.new(user, record) }

  fixtures :all

  let(:record) { users(:john).leaves.create! type: :paid, title: "Holidays", days: [2.weeks.from_now, 15.days.from_now] }

  describe "for a regular user" do
    let(:user) { users(:john) } # regular user

    it "permits destruction of their own leave record if the leave is more than one week away" do
      is_expected.to permit_action(:destroy)
    end

    it "forbids destruction of their own leave record if the leave is within one week" do
      record.leave_during = (Time.zone.today..6.days.from_now)
      is_expected.to forbid_action(:destroy)
    end

    it "forbids updates of their own leave record if the leave ends in the past" do
      record.leave_during = (5.days.ago..1.day.ago)
      is_expected.to forbid_action(:update)
    end

    it "permits updates of their own leave record if the leave ends today" do
      record.leave_during = (5.days.ago..Time.zone.today)
      is_expected.to permit_action(:update)
    end

    it "permits updates of their own leave record if the leave ends in the future" do
      record.leave_during = (5.days.ago..1.day.from_now)
      is_expected.to permit_action(:update)
    end

    describe "permitted_attributes" do
      it "returns all attributes except status" do
        expect(subject.permitted_attributes).to contain_exactly(:title, :type, days: [])
      end
    end
  end

  describe "for an HR user" do
    let(:user) { users(:admin) } # HR user

    it { is_expected.to permit_actions([:edit, :update, :destroy, :hr_overview]) }

    describe "permitted_attributes" do
      it "returns all attributes" do
        expect(subject.permitted_attributes).to contain_exactly(:title, :type, :status, days: [])
      end
    end
  end
end
