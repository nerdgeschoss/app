# frozen_string_literal: true

class GithubImportJob < ApplicationJob
  queue_as :import
  limits_concurrency to: 1, key: ->(job) { job.class.name }, duration: 1.hour

  def perform
    Task.sync_with_github
  end
end
