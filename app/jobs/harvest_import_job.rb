class HarvestImportJob < ApplicationJob
  queue_as :import

  def perform
    Sprint.within(1.year).find_each(&:sync_with_harvest)
  end
end
