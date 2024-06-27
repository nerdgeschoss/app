# frozen_string_literal: true

class HarvestImportJob < ApplicationJob
  queue_as :import

  def perform
    Project.sync_with_harvest
    Invoice.sync_with_harvest
    Sprint.within(2.months).find_each(&:sync_with_harvest)
  end
end
