# frozen_string_literal: true

class HarvestImportJob < ApplicationJob
  queue_as :import
  # sidekiq_options retry: 0

  def perform
    Project.sync_with_harvest
    Invoice.sync_with_harvest
    Sprint.within(1.year).find_each(&:sync_with_harvest)
  end
end
