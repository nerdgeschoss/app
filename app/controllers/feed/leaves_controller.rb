# frozen_string_literal: true

module Feed
  class LeavesController < FeedController
    def index
      @leaves = Leave.all
      respond_to :ics
    end
  end
end
