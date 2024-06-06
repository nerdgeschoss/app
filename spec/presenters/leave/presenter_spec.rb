# frozen_string_literal: true

require "rails_helper"

RSpec.describe Leave::Presenter do
  fixtures :all
  let(:user) { users(:john) }
  let(:holiday) { user.leaves.create! type: :paid, title: "Holidays", days: ["2023-01-02", "2023-01-03"] }
  let(:single_day_sick_leave) { user.leaves.create! type: :sick, title: "Sick", days: ["2023-01-02"] }
  let(:presenter) { described_class.new(leave) }

  context "slack emoji" do
    describe "for paid leave" do
      let(:leave) { holiday }

      it "returns the palm tree emoji" do
        expect(presenter.slack_emoji).to eq ":beach_with_umbrella:"
      end
    end

    describe "for unpaid leave" do
      let(:leave) { holiday }

      before do
        holiday.update! type: :unpaid
      end

      it "returns the palm tree emoji" do
        expect(presenter.slack_emoji).to eq ":beach_with_umbrella:"
      end
    end

    describe "for sick leave" do
      let(:leave) { single_day_sick_leave }

      it "returns the sick emoji" do
        expect(presenter.slack_emoji).to eq ":face_with_thermometer:"
      end
    end

    describe "for non-working days" do
      let(:leave) { holiday }

      before do
        holiday.update! type: :non_working
      end

      it "returns the luggage emoji" do
        expect(presenter.slack_emoji).to eq ":luggage:"
      end
    end
  end

  context "unicode emoji" do
    describe "for paid leave" do
      let(:leave) { holiday }

      it "returns the beach with umbrella emoji" do
        expect(presenter.unicode_emoji).to eq "\u{1F3D6}"
      end
    end

    describe "for unpaid leave" do
      let(:leave) { holiday }

      before do
        holiday.update! type: :unpaid
      end

      it "returns the camping emoji" do
        expect(presenter.unicode_emoji).to eq "\u{1F3D5}"
      end
    end

    describe "for non-working days" do
      let(:leave) { holiday }

      before do
        holiday.update! type: :non_working
      end

      it "returns the luggage emoji" do
        expect(presenter.unicode_emoji).to eq "\u{1F9F3}"
      end
    end

    describe "for sick leave" do
      let(:leave) { single_day_sick_leave }

      it "returns the face with thermometer emoji" do
        expect(presenter.unicode_emoji).to eq "\u{1F912}"
      end
    end
  end
end
