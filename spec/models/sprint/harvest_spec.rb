# frozen_string_literal: true

# == Schema Information
#
# Table name: sprints
#
#  id            :uuid             not null, primary key
#  sprint_during :daterange        not null
#  title         :string           not null
#  working_days  :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Sprint::Harvest do
  fixtures :all

  describe "#sync_with_harvest" do
    let(:sprint) { sprints(:empty) }

    it "imports time entries from harvest" do
      allow(HarvestApi.instance).to receive(:time_entries).and_return(
        [
          HarvestApi::TimeEntry.new(
            id: "12345",
            date: Date.new(2023, 1, 1),
            hours: 7.2,
            rounded_hours: 8,
            billable: true,
            project: "Test Project",
            project_id: "67890",
            invoice_id: "54321",
            client: "Test Client",
            task: "Development",
            billable_rate: 100.0,
            cost_rate: 80.0,
            notes: "Worked on feature X",
            user: "john@example.com"
          )
        ]
      )
      sprint.sync_with_harvest
      expect(sprint.time_entries.sole).to have_attributes(
        external_id: "12345",
        hours: 7.2,
        rounded_hours: 8,
        project_name: "Test Project",
        task: "Development"
      )
    end

    it "allows overwriting the email" do
      allow(HarvestApi.instance).to receive(:time_entries).and_return(
        [
          HarvestApi::TimeEntry.new(
            id: "12345",
            date: Date.new(2023, 1, 1),
            hours: 7.2,
            rounded_hours: 8,
            billable: true,
            project: "Test Project",
            project_id: "67890",
            invoice_id: "54321",
            client: "Test Client",
            task: "Development",
            billable_rate: 100.0,
            cost_rate: 80.0,
            notes: "Worked on feature X",
            user: "john+harvest@example.com"
          )
        ]
      )
      sprint.sync_with_harvest
      expect(sprint.time_entries.sole).to have_attributes(
        external_id: "12345"
      )
    end
  end
end
