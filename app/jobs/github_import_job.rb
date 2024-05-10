# frozen_string_literal: true

class GithubImportJob < ApplicationJob
  queue_as :import

  def perform
    Task.sync_with_github
  end
end
