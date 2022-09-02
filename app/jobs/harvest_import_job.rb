class HarvestImportJob < ApplicationJob
  queue_as :import
  sidekiq_options retry: 0

  def perform
    Sprint.within(1.year).find_each(&:sync_with_harvest)
  end
end
