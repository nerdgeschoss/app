require "active_support/all"
require "ostruct"
require "thor"
require "netrc"
require "faraday"

require_relative "nerdgeschoss_client/version"
require_relative "nerdgeschoss_client/credentials"
require_relative "nerdgeschoss_client/api"
require_relative "nerdgeschoss_client/cli/base"
require_relative "nerdgeschoss_client/cli/auth"
require_relative "nerdgeschoss_client/cli/user"
require_relative "nerdgeschoss_client/cli/main"

module NerdgeschossClient
  BASE_URL = URI.parse(ENV["NERDGESCHOSS_BASE_URL"] || "https://app.nerdgeschoss.de").freeze

  class Error < StandardError; end

  class NetworkError < Error; end

  class PresentableError < Error; end
end
